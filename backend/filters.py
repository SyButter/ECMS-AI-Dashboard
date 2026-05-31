"""
filters.py — Shared query filter builder
=========================================
All dashboard endpoints accept the same set of optional filters.
This module centralises the logic so every router uses it consistently.

Filters:
  division       — division code e.g. EPD, CMD
  year           — fiscal year e.g. 2025
  quarter        — fiscal quarter 1-4
  solicitation   — solicitation type label e.g. Task Order
  firm           — firm name (partial match)
  firm_id        — exact firm ID
  site           — site code e.g. JFK, LGA
  date_from      — award date range start YYYY-MM-DD
  date_to        — award date range end YYYY-MM-DD
"""

from typing import Optional
from fastapi import Query


class AwardFilters:
    """
    Dependency class — FastAPI injects this into route functions.
    Builds the WHERE clause and params list for v_awards_detail queries.

    Usage:
        @router.get("/example")
        def example(filters: AwardFilters = Depends()):
            where, params = filters.build()
    """

    def __init__(
        self,
        division: Optional[str]  = Query(None, description="Division code e.g. EPD"),
        year: Optional[int]      = Query(None, description="Fiscal year e.g. 2025"),
        quarter: Optional[int]   = Query(None, description="Fiscal quarter 1-4"),
        solicitation: Optional[str] = Query(None, description="Solicitation type"),
        firm: Optional[str]      = Query(None, description="Firm name (partial)"),
        firm_id: Optional[int]   = Query(None, description="Exact firm ID"),
        site: Optional[str]      = Query(None, description="Site code e.g. JFK"),
        date_from: Optional[str] = Query(None, description="Award date from YYYY-MM-DD"),
        date_to: Optional[str]   = Query(None, description="Award date to YYYY-MM-DD"),
    ):
        self.division     = division
        self.year         = year
        self.quarter      = quarter
        self.solicitation = solicitation
        self.firm         = firm
        self.firm_id      = firm_id
        self.site         = site
        self.date_from    = date_from
        self.date_to      = date_to

    def build(self) -> tuple[str, list]:
        """
        Returns (where_clause, params) ready to append to a SQL query.
        where_clause is empty string if no filters are set.
        """
        conditions = []
        params = []

        if self.division:
            conditions.append("division_code = %s")
            params.append(self.division)

        if self.year:
            conditions.append("fiscal_year = %s")
            params.append(self.year)

        if self.quarter:
            conditions.append("fiscal_quarter = %s")
            params.append(self.quarter)

        if self.solicitation:
            conditions.append("solicitation_type = %s")
            params.append(self.solicitation)

        if self.firm:
            conditions.append("awarded_firm LIKE %s")
            params.append(f"%{self.firm}%")

        if self.firm_id:
            conditions.append("award_id IN (SELECT award_id FROM awards WHERE firm_id = %s)")
            params.append(self.firm_id)

        if self.site:
            conditions.append("site_code = %s")
            params.append(self.site)

        if self.date_from:
            conditions.append("award_date >= %s")
            params.append(self.date_from)

        if self.date_to:
            conditions.append("award_date <= %s")
            params.append(self.date_to)

        where = ("WHERE " + " AND ".join(conditions)) if conditions else ""
        return where, params
