# ECMS — Engineering Contract Management System

AI-powered contract intelligence platform for the Port Authority Engineering division.

Replaces manual Excel-based contract tracking and static PowerBI dashboards with a live web dashboard and AI chat interface. Staff can ask questions in plain English, get instant answers from live contract data, build reports on the fly, and automate workflows that currently require hours of manual lookup work.

---

## The Problem

The Engineering division manages hundreds of contracts, firms, task orders, and workflows across Excel spreadsheets that must be manually updated. When management needs to answer a question — why wasn't Firm X awarded, how much have we given Firm Y over 5 years, which workflows are stuck — a staff member spends hours pulling records across multiple files. Duplicate firm records go undetected. MBE compliance is tracked manually. Workflow bottlenecks are invisible.

## The Solution

Three layers that together eliminate most of that manual work:

**Layer 1 — Live Database**
All contract data lives in MySQL instead of Excel. The Excel file imports into the database automatically. Every number on every dashboard and every AI answer comes from the same single source of truth.

**Layer 2 — Live Dashboard**
A React web app replaces the static PowerBI file. Same panels — KPI cards, trend charts, division/firm/site breakdowns, detailed award log — but filterable in real time, accessible in any browser, always showing current data.

**Layer 3 — AI Chat (Phase 5)**
Claude sits on top of the database. Staff type questions in plain English and get instant answers — with charts built on the fly, firm profiles surfaced in seconds, duplicate records flagged automatically, and workflow status reported without anyone pulling a report.

---

## AI Use Cases

| Use Case | What the AI Does |
|----------|-----------------|
| On-demand queries | "Show top 10 firms by spend on the Bridge program" → ranked table instantly |
| Why wasn't firm X awarded? | Checks communications log, solicitation responses, performance letters |
| Duplicate firm detection | Scans hundreds of records, clusters near-matches, drafts outreach emails |
| Build a dashboard | Staff describe what they want, AI generates the chart inline |
| Firm profile Q&A | TOs issued, agreements, subs and % paid, MBE committed vs actual, % complete |
| Workflow monitoring | "Which WFs are stuck?" → list with owner, days overdue, current stage |
| MBE tracking | Committed vs paid vs actual per firm per program |
| Sub-award breakdown | Who are the subs and what % of the prime did they receive |
| Site-level queries | "How many TOs at JFK?" → filtered by site code |
| Program financials | Authorized → Awarded → Actually Spent drill-down |

---

## Project Status

| Phase | Description | Status |
|-------|-------------|--------|
| 1 | MySQL database schema + mock data | ✅ Complete |
| 2 | Excel import script | ✅ Complete |
| 3 | FastAPI backend API | ✅ Complete |
| 4 | React dashboard | ✅ Complete |
| 5 | AI chat layer | 🔄 Next |
| 6 | Firm intelligence + dedup engine | ⏳ Pending |
| 7 | Workflow + OpenText integration | ⏳ Pending |

---

## Architecture

```
Excel Workbook (ECMS_Headers.xlsx)
        ↓  scripts/import_excel.py
MySQL Database (12 tables, 14 views)
        ↓  FastAPI backend
REST API (26 endpoints, /api/*)
        ↓
   ┌────┴────┐
React Dashboard    AI Chat Layer
(live charts)      (Claude API)
```

**AI Query Flow:**
```
Staff types question
        ↓
React chat interface
        ↓
POST /api/chat  →  Claude API
                   (receives question + full DB schema)
                        ↓
                   Calls /api/* endpoints to get data
                        ↓
                   Formats answer + optional chart
        ↓
Answer rendered in chat window
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Database | MySQL 8.0 |
| Import Script | Python 3.11 + openpyxl |
| Backend API | FastAPI (Python) |
| Frontend | React 18 + Vite + Recharts + Tailwind CSS |
| AI Layer | Anthropic Claude API |

---

## Database — 12 Tables, 14 Views

**Tables**

| Table | Description | Excel Source |
|-------|-------------|-------------|
| `divisions` | EPD, CMD, EAD, EOD, QAD, EAM, MEU, EADD | Reference data |
| `units` | Sub-units per division | Reference data |
| `categories` | Work categories (Bridges, Geotechnical, etc.) | Data Level — Category 1-4 |
| `solicitation_types` | Task Order, Small Contracts, SBE Set-Aside... | Summary Level — Program Type |
| `sites` | JFK, LGA, EWR, HQ, etc. | Extended |
| `firms` | All vendor firms with certifications | Data Level |
| `programs` | RFPs / Agreement Lists | Summary Level |
| `program_firms` | Which firms are listed on each program | Data Level |
| `awards` | Every awarded task order / contract action | Summary Level |
| `sub_awards` | Sub-contractor relationships and payments | Extended |
| `mbe_tracking` | MBE committed vs paid vs actual | Extended |
| `communications` | Email log per firm/program | Extended |
| `performance_letters` | Formal performance records | Extended |
| `workflows` | RFP/TO/CO/Board Auth status | Extended |
| `spend_tracking` | Actual PO/invoice spend vs awarded | Extended |
| `agreement_progress` | % complete per active agreement | Extended |

**Views** — one per dashboard panel or AI use case:
`v_awards_detail`, `v_kpi_totals`, `v_top_firms`, `v_quarterly_trend`,
`v_by_division`, `v_by_solicitation_type`, `v_by_site`, `v_program_financials`,
`v_firm_profile`, `v_duplicate_firms`, `v_stuck_workflows`,
`v_mbe_summary`, `v_sub_award_summary`

---

## API Endpoints — 26 Total

**Dashboard**
```
GET /api/kpis                   Header KPI cards
GET /api/awards/by-type         Donut chart
GET /api/awards/by-division     Division bar chart
GET /api/awards/by-firm         Top firms table
GET /api/awards/by-site         Site breakdown
GET /api/awards/trend           Quarterly trend chart
GET /api/awards                 Paginated detailed table
GET /api/filters                All dropdown options
```

**Programs**
```
GET /api/programs               List all programs
GET /api/programs/{id}          Program detail
GET /api/programs/{id}/financials  Authorized vs awarded vs spent
GET /api/programs/{id}/firms    Firms listed on program
GET /api/programs/{id}/awards   All awards on program
```

**Firms**
```
GET /api/firms                  List all firms
GET /api/firms/duplicates       Duplicate clusters
GET /api/firms/{id}             Full firm profile
GET /api/firms/{id}/awards      Award history + summary stats
GET /api/firms/{id}/sub-awards  Sub-contractor breakdown
GET /api/firms/{id}/mbe         MBE committed vs paid vs actual
GET /api/firms/{id}/performance Performance letters
GET /api/firms/{id}/communications Email/comms log
GET /api/firms/{id}/progress    Agreement % complete
```

**Workflows**
```
GET /api/workflows              All workflows
GET /api/workflows/stuck        Stuck / overdue workflows
GET /api/workflows/{id}/history Full audit trail
```

All dashboard endpoints accept filter parameters:
`?division=EPD&year=2025&solicitation=Task+Order&firm=EnTech&site=JFK`

---

## Setup

### Prerequisites
- Python 3.11+
- Node.js 18+
- MySQL 8.0

### 1. Clone and configure

```bash
git clone https://github.com/YOUR_USERNAME/ecms.git
cd ecms
cp .env.example .env
# Edit .env with your MySQL credentials
```

### 2. Database

```bash
mysql -u root -p -e "CREATE DATABASE ecms;"
mysql -u root -p ecms < database/schema.sql
```

### 3. Import Excel data

```bash
pip install -r scripts/requirements.txt
python scripts/import_excel.py --file path/to/ECMS_Headers.xlsx --dry-run
python scripts/import_excel.py --file path/to/ECMS_Headers.xlsx
```

### 4. Run the API

```bash
pip install -r backend/requirements.txt
python -m uvicorn backend.main:app --reload --port 8000
```

API docs: `http://localhost:8000/docs`

### 5. Run the Dashboard

```bash
cd frontend
npm install
npm run dev
```

Dashboard: `http://localhost:3000`

---

## Branch Strategy

```
main                         ← stable, always deployable
dev                          ← integration branch
phase/2-excel-import         ← merged
phase/3-backend              ← merged
phase/4-dashboard            ← merged
phase/5-ai-chat              ← next
phase/6-firm-intelligence
phase/7-workflow-integration
```

---

## Security Rules

- **Never commit `.env`** — contains DB credentials and API keys
- **Never commit real PA data** — Excel files, CSVs, or SQL dumps with real contract data
- **Never commit directly to `main`** — always branch and open a pull request
- Make the GitHub repository **private**
