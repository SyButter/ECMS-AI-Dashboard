"""
routers/firms.py — Firm endpoints
===================================
Endpoints:
  GET /api/firms                    — List all firms
  GET /api/firms/{id}               — Full firm profile
  GET /api/firms/{id}/awards        — All awards to this firm
  GET /api/firms/{id}/sub-awards    — Sub-awards where firm is prime or sub
  GET /api/firms/{id}/mbe           — MBE committed vs paid vs actual
  GET /api/firms/{id}/performance   — Performance letters
  GET /api/firms/{id}/communications — Communication log
  GET /api/firms/{id}/progress      — Agreement % complete
  GET /api/firms/duplicates         — Duplicate firm clusters
"""

from fastapi import APIRouter, Depends, HTTPException
from backend.db import get_db

router = APIRouter(prefix="/api/firms", tags=["Firms"])


@router.get("")
def list_firms(
    is_sbe: bool = None,
    is_mbe: bool = None,
    is_wbe: bool = None,
    search: str  = None,
    db=Depends(get_db)
):
    """List all canonical firms with optional certification filters."""
    conditions = ["f.dedup_canonical = 1"]
    params = []

    if is_sbe:
        conditions.append("f.is_sbe = 1")
    if is_mbe:
        conditions.append("f.is_mbe = 1")
    if is_wbe:
        conditions.append("f.is_wbe = 1")
    if search:
        conditions.append("f.firm_name LIKE %s")
        params.append(f"%{search}%")

    where = "WHERE " + " AND ".join(conditions)
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            f.firm_id, f.firm_name, f.global_vendor_id, f.sap_vendor_number,
            f.is_sbe, f.is_wbe, f.is_dbe, f.is_mbe, f.is_mwbe, f.is_sdvob,
            f.primary_contact_name, f.primary_contact_email,
            f.city, f.state,
            COUNT(DISTINCT a.award_id)      AS total_awards,
            COALESCE(SUM(a.award_amount),0) AS total_awarded
        FROM firms f
        LEFT JOIN awards a ON a.firm_id = f.firm_id
        {where}
        GROUP BY f.firm_id
        ORDER BY total_awarded DESC
    """, params)
    return cursor.fetchall()


@router.get("/duplicates")
def get_duplicate_clusters(db=Depends(get_db)):
    """
    Returns all suspected duplicate firm clusters.
    Use case: AI dedup engine — flag near-identical records for human review.
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM v_duplicate_firms ORDER BY dedup_cluster_id, dedup_canonical DESC")
    rows = cursor.fetchall()

    # Group by cluster for easier frontend rendering
    clusters = {}
    for row in rows:
        cid = row["dedup_cluster_id"]
        if cid not in clusters:
            clusters[cid] = {"cluster_id": cid, "firms": []}
        clusters[cid]["firms"].append(row)

    return list(clusters.values())


@router.get("/{firm_id}")
def get_firm(firm_id: int, db=Depends(get_db)):
    """
    Full firm profile — the AI chat sits on this record.
    Returns everything: certifications, contacts, award totals,
    programs, performance letter count, sub-award count.
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM v_firm_profile WHERE firm_id = %s", [firm_id])
    row = cursor.fetchone()
    if not row:
        raise HTTPException(status_code=404, detail="Firm not found")
    return row


@router.get("/{firm_id}/awards")
def firm_awards(firm_id: int, db=Depends(get_db)):
    """
    All awards to this firm across all programs and years.
    Use cases:
      - How many TOs were issued to this firm?
      - How much have we given them over the past X years?
      - Which programs are they on?
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            award_id, award_date, fiscal_period, fiscal_year,
            award_amount, award_type, solicitation_type,
            division_code, site_code, site_name,
            agreement_number, po_number, assignment,
            program_title, solicitation_number
        FROM v_awards_detail
        WHERE awarded_firm = (SELECT firm_name FROM firms WHERE firm_id = %s)
        ORDER BY award_date DESC
    """, [firm_id])
    awards = cursor.fetchall()

    # Summary stats alongside the detail rows
    cursor.execute("""
        SELECT
            COUNT(*)                        AS total_awards,
            COALESCE(SUM(award_amount), 0)  AS total_awarded,
            MIN(award_date)                 AS first_award,
            MAX(award_date)                 AS last_award,
            COUNT(DISTINCT fiscal_year)     AS years_active,
            COUNT(DISTINCT division_code)   AS divisions_count,
            COUNT(DISTINCT solicitation_number) AS programs_count
        FROM v_awards_detail
        WHERE awarded_firm = (SELECT firm_name FROM firms WHERE firm_id = %s)
    """, [firm_id])

    return {
        "summary": cursor.fetchone(),
        "awards":  awards,
    }


@router.get("/{firm_id}/sub-awards")
def firm_sub_awards(firm_id: int, db=Depends(get_db)):
    """
    Sub-awards where this firm is the prime contractor.
    Use case: Who were the subs and what % did they receive?
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT * FROM v_sub_award_summary
        WHERE prime_firm = (SELECT firm_name FROM firms WHERE firm_id = %s)
        ORDER BY paid_amount DESC
    """, [firm_id])
    return cursor.fetchall()


@router.get("/{firm_id}/mbe")
def firm_mbe(firm_id: int, db=Depends(get_db)):
    """
    MBE committed vs paid vs actual for this firm.
    Use case: MBE tracking panel on firm profile.
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT * FROM v_mbe_summary
        WHERE prime_firm = (SELECT firm_name FROM firms WHERE firm_id = %s)
        ORDER BY reporting_period DESC
    """, [firm_id])
    rows = cursor.fetchall()

    # Aggregate totals
    cursor.execute("""
        SELECT
            COALESCE(SUM(committed_amount), 0) AS total_committed,
            COALESCE(SUM(paid_amount), 0)      AS total_paid,
            COALESCE(SUM(actual_amount), 0)    AS total_actual
        FROM mbe_tracking
        WHERE prime_firm_id = %s
    """, [firm_id])

    return {
        "totals":  cursor.fetchone(),
        "records": rows,
    }


@router.get("/{firm_id}/performance")
def firm_performance(firm_id: int, db=Depends(get_db)):
    """
    Performance letters for this firm.
    Use case: Why wasn't this firm awarded? Did they have performance issues?
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            pl.letter_id, pl.letter_type, pl.letter_date,
            pl.issued_by, pl.description, pl.resolution, pl.is_active,
            p.rfp_number, p.program_title
        FROM performance_letters pl
        LEFT JOIN programs p ON p.program_id = pl.program_id
        WHERE pl.firm_id = %s
        ORDER BY pl.letter_date DESC
    """, [firm_id])
    return cursor.fetchall()


@router.get("/{firm_id}/communications")
def firm_communications(firm_id: int, db=Depends(get_db)):
    """
    Full communication log for this firm.
    Use case: Did they respond to solicitation X? Were they notified of non-award?
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            c.comm_id, c.comm_type, c.comm_date,
            c.sent_by, c.subject, c.body_summary, c.has_attachment,
            p.rfp_number, p.program_title
        FROM communications c
        LEFT JOIN programs p ON p.program_id = c.program_id
        WHERE c.firm_id = %s
        ORDER BY c.comm_date DESC
    """, [firm_id])
    return cursor.fetchall()


@router.get("/{firm_id}/progress")
def firm_agreement_progress(firm_id: int, db=Depends(get_db)):
    """
    % complete across all active agreements for this firm.
    Use case: What is the % complete of their current agreements?
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            a.po_number, a.agreement_number, a.award_date, a.award_amount,
            p.program_title, p.rfp_number,
            ap.total_contract_value, ap.amount_billed, ap.amount_paid,
            ap.pct_complete, ap.status,
            ap.last_invoice_date, ap.estimated_completion
        FROM agreement_progress ap
        JOIN awards   a ON a.award_id   = ap.award_id
        JOIN programs p ON p.program_id = a.program_id
        WHERE a.firm_id = %s
        ORDER BY ap.status, ap.pct_complete DESC
    """, [firm_id])
    return cursor.fetchall()
