"""
routers/programs.py — Program endpoints
========================================
Endpoints:
  GET /api/programs              — List all programs with filters
  GET /api/programs/{id}         — Single program detail
  GET /api/programs/{id}/financials — Authorized vs awarded vs spent
  GET /api/programs/{id}/firms   — Firms listed on this program
  GET /api/programs/{id}/awards  — All awards against this program
"""

from fastapi import APIRouter, Depends, HTTPException
from backend.db import get_db

router = APIRouter(prefix="/api/programs", tags=["Programs"])


@router.get("")
def list_programs(
    division: str = None,
    status: str = None,
    db=Depends(get_db)
):
    """List all programs, optionally filtered by division or status."""
    conditions, params = [], []
    if division:
        conditions.append("d.division_code = %s")
        params.append(division)
    if status:
        conditions.append("p.status = %s")
        params.append(status)

    where = ("WHERE " + " AND ".join(conditions)) if conditions else ""
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            p.program_id, p.rfp_number, p.program_title,
            p.agreement_number, p.status, p.program_type,
            d.division_code, d.division_name,
            st.type_label AS solicitation_type,
            p.authorized_amount, p.ice_estimate,
            p.num_firms_on_list, p.num_submissions,
            p.solicitation_date, p.valid_from, p.valid_to,
            p.pm_name, p.pa_contact, p.security_level
        FROM programs p
        JOIN divisions d ON d.division_id = p.division_id
        JOIN solicitation_types st ON st.type_id = p.solicitation_type_id
        {where}
        ORDER BY p.solicitation_date DESC
    """, params)
    return cursor.fetchall()


@router.get("/{program_id}")
def get_program(program_id: int, db=Depends(get_db)):
    """Full detail for a single program."""
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            p.*,
            d.division_code, d.division_name,
            st.type_label AS solicitation_type,
            u.unit_name
        FROM programs p
        JOIN divisions d ON d.division_id = p.division_id
        JOIN solicitation_types st ON st.type_id = p.solicitation_type_id
        LEFT JOIN units u ON u.unit_id = p.unit_id
        WHERE p.program_id = %s
    """, [program_id])
    row = cursor.fetchone()
    if not row:
        raise HTTPException(status_code=404, detail="Program not found")
    return row


@router.get("/{program_id}/financials")
def program_financials(program_id: int, db=Depends(get_db)):
    """
    Authorized vs awarded vs spent for one program.
    Use case: '$600M authorized, $50M awarded, $1M actually spent via POs'
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT * FROM v_program_financials
        WHERE rfp_number = (SELECT rfp_number FROM programs WHERE program_id = %s)
    """, [program_id])
    row = cursor.fetchone()
    if not row:
        raise HTTPException(status_code=404, detail="Program not found")
    return row


@router.get("/{program_id}/firms")
def program_firms(program_id: int, db=Depends(get_db)):
    """All firms listed on this program (the pool before award)."""
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            f.firm_id, f.firm_name, f.global_vendor_id,
            f.is_sbe, f.is_wbe, f.is_mbe, f.is_dbe, f.is_mwbe,
            f.primary_contact_name, f.primary_contact_email,
            pf.agmt_firm_record, pf.is_on_scp_list, pf.date_added
        FROM program_firms pf
        JOIN firms f ON f.firm_id = pf.firm_id
        WHERE pf.program_id = %s AND pf.is_active = 1
        ORDER BY f.firm_name
    """, [program_id])
    return cursor.fetchall()


@router.get("/{program_id}/awards")
def program_awards(program_id: int, db=Depends(get_db)):
    """All awards issued against this program."""
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            award_id, award_date, fiscal_period,
            award_amount, award_type, solicitation_type,
            awarded_firm, division_code, site_code,
            agreement_number, po_number, assignment
        FROM v_awards_detail
        WHERE solicitation_number = (SELECT rfp_number FROM programs WHERE program_id = %s)
        ORDER BY award_date DESC
    """, [program_id])
    return cursor.fetchall()
