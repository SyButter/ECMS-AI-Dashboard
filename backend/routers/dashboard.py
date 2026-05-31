"""
routers/dashboard.py — Dashboard endpoints
===========================================
Powers all the visual panels on the main dashboard page.

Endpoints:
  GET /api/kpis              — Header KPI cards
  GET /api/awards/by-type    — Donut chart (solicitation type breakdown)
  GET /api/awards/by-division — Division bar chart
  GET /api/awards/by-firm    — Top firms table and bar chart
  GET /api/awards/by-site    — Site breakdown (JFK / LGA / EWR)
  GET /api/awards/trend      — Quarterly trend bar chart
  GET /api/awards            — Full detailed award table (paginated)
  GET /api/filters           — All dropdown filter options
"""

from fastapi import APIRouter, Depends
from backend.db import get_db
from backend.filters import AwardFilters

router = APIRouter(prefix="/api", tags=["Dashboard"])


# ---------------------------------------------------------------------------
# KPI Cards
# ---------------------------------------------------------------------------

@router.get("/kpis")
def get_kpis(filters: AwardFilters = Depends(), db=Depends(get_db)):
    """
    Returns the four header KPI cards:
      - Total award amount and count
      - Task Order amount and count
      - Small Contracts amount and count
      - SBE Set-Aside amount and count
    """
    where, params = filters.build()
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            COUNT(*)                                                              AS total_awards,
            COALESCE(SUM(award_amount), 0)                                        AS total_award_amt,
            COALESCE(SUM(CASE WHEN solicitation_type = 'Task Order'      THEN award_amount END), 0) AS task_order_amt,
            COALESCE(SUM(CASE WHEN solicitation_type = 'Task Order'      THEN 1 END), 0)            AS task_order_count,
            COALESCE(SUM(CASE WHEN solicitation_type = 'Small Contracts' THEN award_amount END), 0) AS small_contracts_amt,
            COALESCE(SUM(CASE WHEN solicitation_type = 'Small Contracts' THEN 1 END), 0)            AS small_contracts_count,
            COALESCE(SUM(CASE WHEN solicitation_type = 'SBE Set-Aside'  THEN award_amount END), 0) AS sbe_amt,
            COALESCE(SUM(CASE WHEN solicitation_type = 'SBE Set-Aside'  THEN 1 END), 0)            AS sbe_count
        FROM v_awards_detail
        {where}
    """, params)
    return cursor.fetchone()


# ---------------------------------------------------------------------------
# Donut Chart — By Solicitation Type
# ---------------------------------------------------------------------------

@router.get("/awards/by-type")
def awards_by_type(filters: AwardFilters = Depends(), db=Depends(get_db)):
    """
    Breakdown by solicitation type — powers the donut chart.
    Returns: solicitation_type, awards_amt, num_awards, pct
    """
    where, params = filters.build()
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            solicitation_type,
            COALESCE(SUM(award_amount), 0)  AS awards_amt,
            COUNT(*)                        AS num_awards,
            ROUND(
                COALESCE(SUM(award_amount), 0) /
                NULLIF((SELECT SUM(award_amount) FROM v_awards_detail {where}), 0) * 100
            , 2) AS pct
        FROM v_awards_detail
        {where}
        GROUP BY solicitation_type
        ORDER BY awards_amt DESC
    """, params + params)
    return cursor.fetchall()


# ---------------------------------------------------------------------------
# Division Bar Chart
# ---------------------------------------------------------------------------

@router.get("/awards/by-division")
def awards_by_division(filters: AwardFilters = Depends(), db=Depends(get_db)):
    """
    Awards grouped by division — powers the division bar chart.
    Returns: division_code, division_name, awards_amt, num_awards, pct
    """
    where, params = filters.build()
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            division_code,
            division_name,
            COALESCE(SUM(award_amount), 0)  AS awards_amt,
            COUNT(*)                        AS num_awards,
            ROUND(
                COALESCE(SUM(award_amount), 0) /
                NULLIF((SELECT SUM(award_amount) FROM v_awards_detail {where}), 0) * 100
            , 2) AS pct
        FROM v_awards_detail
        {where}
        GROUP BY division_code, division_name
        ORDER BY awards_amt DESC
    """, params + params)
    return cursor.fetchall()


# ---------------------------------------------------------------------------
# Top Firms Table + Bar Chart
# ---------------------------------------------------------------------------

@router.get("/awards/by-firm")
def awards_by_firm(
    limit: int = 10,
    filters: AwardFilters = Depends(),
    db=Depends(get_db)
):
    """
    Top firms ranked by total award amount.
    Returns: awarded_firm, awards_amt, num_awards, pct, solicitation_types, divisions
    """
    where, params = filters.build()
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            awarded_firm,
            COALESCE(SUM(award_amount), 0)  AS awards_amt,
            COUNT(*)                        AS num_awards,
            ROUND(
                COALESCE(SUM(award_amount), 0) /
                NULLIF((SELECT SUM(award_amount) FROM v_awards_detail {where}), 0) * 100
            , 2) AS awards_amt_pct,
            GROUP_CONCAT(DISTINCT solicitation_type ORDER BY solicitation_type SEPARATOR ', ') AS solicitation_types,
            GROUP_CONCAT(DISTINCT division_code     ORDER BY division_code     SEPARATOR ', ') AS divisions,
            MIN(award_date) AS first_award_date,
            MAX(award_date) AS last_award_date
        FROM v_awards_detail
        {where}
        GROUP BY awarded_firm
        ORDER BY awards_amt DESC
        LIMIT %s
    """, params + params + [limit])
    return cursor.fetchall()


# ---------------------------------------------------------------------------
# Site Breakdown (JFK / LGA / EWR)
# ---------------------------------------------------------------------------

@router.get("/awards/by-site")
def awards_by_site(filters: AwardFilters = Depends(), db=Depends(get_db)):
    """
    Awards grouped by site — powers the site breakdown panel.
    Returns: site_code, site_name, awards_amt, num_awards
    """
    where, params = filters.build()
    # Add site filter that excludes nulls
    site_where = (where + " AND site_code IS NOT NULL") if where else "WHERE site_code IS NOT NULL"
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            site_code,
            site_name,
            COALESCE(SUM(award_amount), 0)  AS awards_amt,
            COUNT(*)                        AS num_awards
        FROM v_awards_detail
        {site_where}
        GROUP BY site_code, site_name
        ORDER BY awards_amt DESC
    """, params)
    return cursor.fetchall()


# ---------------------------------------------------------------------------
# Quarterly Trend Chart
# ---------------------------------------------------------------------------

@router.get("/awards/trend")
def awards_trend(filters: AwardFilters = Depends(), db=Depends(get_db)):
    """
    Award totals by fiscal quarter — powers the trend bar chart.
    Returns: fiscal_year, fiscal_quarter, fiscal_period, total_amt, num_awards
    """
    where, params = filters.build()
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            fiscal_year,
            fiscal_quarter,
            fiscal_period,
            COALESCE(SUM(award_amount), 0)  AS total_amt,
            COUNT(*)                        AS num_awards
        FROM v_awards_detail
        {where}
        GROUP BY fiscal_year, fiscal_quarter, fiscal_period
        ORDER BY fiscal_year, fiscal_quarter
    """, params)
    return cursor.fetchall()


# ---------------------------------------------------------------------------
# Detailed Award Table (paginated)
# ---------------------------------------------------------------------------

@router.get("/awards")
def get_awards(
    page: int = 1,
    page_size: int = 50,
    sort_by: str = "award_date",
    sort_dir: str = "desc",
    filters: AwardFilters = Depends(),
    db=Depends(get_db)
):
    """
    Full paginated award log — powers the Detailed View table.
    Returns: awards array + pagination metadata
    """
    # Whitelist sortable columns to prevent SQL injection
    allowed_sort = {
        "award_date", "award_amount", "awarded_firm",
        "division_code", "solicitation_type", "fiscal_year"
    }
    sort_by  = sort_by  if sort_by  in allowed_sort else "award_date"
    sort_dir = "DESC"   if sort_dir.lower() == "desc" else "ASC"

    where, params = filters.build()
    offset = (page - 1) * page_size
    cursor = db.cursor(dictionary=True)

    # Total count for pagination
    cursor.execute(f"SELECT COUNT(*) AS total FROM v_awards_detail {where}", params)
    total = cursor.fetchone()["total"]

    # Paginated data
    cursor.execute(f"""
        SELECT
            award_id, award_date, fiscal_period,
            award_amount, award_type, solicitation_type,
            awarded_firm, division_code, site_code,
            agreement_number, po_number, assignment,
            program_title, solicitation_number, solicitation_date
        FROM v_awards_detail
        {where}
        ORDER BY {sort_by} {sort_dir}
        LIMIT %s OFFSET %s
    """, params + [page_size, offset])

    return {
        "data":      cursor.fetchall(),
        "page":      page,
        "page_size": page_size,
        "total":     total,
        "pages":     -(-total // page_size),  # ceiling division
    }


# ---------------------------------------------------------------------------
# Filter Dropdown Options
# ---------------------------------------------------------------------------

@router.get("/filters")
def get_filter_options(db=Depends(get_db)):
    """
    Returns all valid options for the dashboard filter dropdowns.
    Called once on page load to populate Period, Division, Category,
    Solicitation Type, Awarded Firm, and Site dropdowns.
    """
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT DISTINCT fiscal_year AS value FROM v_awards_detail ORDER BY fiscal_year DESC")
    years = [r["value"] for r in cursor.fetchall()]

    cursor.execute("SELECT DISTINCT division_code AS value FROM v_awards_detail WHERE division_code IS NOT NULL ORDER BY division_code")
    divisions = [r["value"] for r in cursor.fetchall()]

    cursor.execute("SELECT DISTINCT solicitation_type AS value FROM v_awards_detail WHERE solicitation_type IS NOT NULL ORDER BY solicitation_type")
    solicitation_types = [r["value"] for r in cursor.fetchall()]

    cursor.execute("SELECT DISTINCT awarded_firm AS value FROM v_awards_detail WHERE awarded_firm IS NOT NULL ORDER BY awarded_firm")
    firms = [r["value"] for r in cursor.fetchall()]

    cursor.execute("SELECT DISTINCT site_code AS value FROM v_awards_detail WHERE site_code IS NOT NULL ORDER BY site_code")
    sites = [r["value"] for r in cursor.fetchall()]

    cursor.execute("SELECT DISTINCT category_name AS value FROM categories ORDER BY category_name")
    categories = [r["value"] for r in cursor.fetchall()]

    return {
        "years":             years,
        "divisions":         divisions,
        "solicitation_types": solicitation_types,
        "firms":             firms,
        "sites":             sites,
        "categories":        categories,
    }
