"""
routers/workflows.py — Workflow status endpoints
==================================================
Endpoints:
  GET /api/workflows              — All workflows with optional filters
  GET /api/workflows/stuck        — Only stuck / overdue workflows
  GET /api/workflows/{id}/history — Full audit trail for one workflow
"""

from fastapi import APIRouter, Depends
from backend.db import get_db

router = APIRouter(prefix="/api/workflows", tags=["Workflows"])


@router.get("")
def list_workflows(
    workflow_type: str = None,
    assigned_to:   str = None,
    db=Depends(get_db)
):
    """All workflows with optional type and assignee filters."""
    conditions, params = [], []
    if workflow_type:
        conditions.append("w.workflow_type = %s")
        params.append(workflow_type)
    if assigned_to:
        conditions.append("w.assigned_to LIKE %s")
        params.append(f"%{assigned_to}%")

    where = ("WHERE " + " AND ".join(conditions)) if conditions else ""
    cursor = db.cursor(dictionary=True)
    cursor.execute(f"""
        SELECT
            w.workflow_id, w.workflow_type, w.workflow_ref,
            ws.state_label AS current_stage,
            p.rfp_number, p.program_title,
            w.assigned_to, w.created_by,
            w.created_date, w.due_date, w.completed_date,
            w.is_stuck, w.stuck_reason,
            w.sent_to_procurement, w.procurement_date,
            DATEDIFF(CURDATE(), w.due_date) AS days_overdue
        FROM workflows w
        JOIN workflow_states ws ON ws.state_id = w.current_state_id
        LEFT JOIN programs   p  ON p.program_id = w.program_id
        {where}
        ORDER BY w.due_date ASC
    """, params)
    return cursor.fetchall()


@router.get("/stuck")
def stuck_workflows(db=Depends(get_db)):
    """
    Workflows that are stuck or overdue.
    Use case: 'Which WFs are stuck right now? Which went to procurement?'
    """
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM v_stuck_workflows")
    return cursor.fetchall()


@router.get("/{workflow_id}/history")
def workflow_history(workflow_id: int, db=Depends(get_db)):
    """Full state change audit trail for one workflow document."""
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT
            wh.history_id,
            ws_from.state_label AS from_stage,
            ws_to.state_label   AS to_stage,
            wh.changed_by, wh.changed_at, wh.comment
        FROM workflow_history wh
        LEFT JOIN workflow_states ws_from ON ws_from.state_id = wh.from_state_id
        JOIN  workflow_states ws_to   ON ws_to.state_id   = wh.to_state_id
        WHERE wh.workflow_id = %s
        ORDER BY wh.changed_at ASC
    """, [workflow_id])
    return cursor.fetchall()
