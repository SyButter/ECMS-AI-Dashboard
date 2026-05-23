# ECMS — Engineering Contract Management System

AI-powered contract intelligence platform for the Port Authority Engineering division.

Replaces static PowerBI dashboards with a live web dashboard and AI chat interface
that lets staff query contract data, build reports on the fly, and automate workflows
that currently require manual Excel processing.

---

## Project Status

| Phase | Description | Status |
|-------|-------------|--------|
| 1 | Database schema + mock data | ✅ Complete |
| 2 | Excel import script | 🔄 Next |
| 3 | FastAPI backend | ⏳ Pending |
| 4 | React dashboard | ⏳ Pending |
| 5 | AI chat layer | ⏳ Pending |
| 6 | Firm intelligence + dedup engine | ⏳ Pending |
| 7 | Workflow + spend tracking integration | ⏳ Pending |

---

## What This System Does

### Dashboard
Live web dashboard replacing PowerBI:
- KPI cards (total award $, # awards by solicitation type)
- Awards by Division, Category, Awarded Firm
- Quarterly trend chart
- Program financials: Authorized → Awarded → Spent
- Filterable detailed award log

### AI Chat
Natural language interface over ECMS data:
- "Show me top 10 firms by spend on the Bridge and Building surveys program"
- "Why wasn't Firm X awarded anything on Program Y?"
- "What is the % complete of EnTech's current agreements?"
- "Which workflows are stuck right now?"
- "Show me MBE committed vs paid vs actual for this quarter"

### Firm Intelligence
- Full firm profile: award history, sub-awards, MBE commitments, performance letters
- Duplicate detection engine across hundreds of firm records
- Auto-generated dedup reports per firm cluster

### Workflow Tracking
- RFP, Task Order, Change Order, Board Authorization status
- Flags stuck workflows with days overdue
- OpenText and procurement portal integration (Phase 7)

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Database | MySQL 8.0 |
| Import Script | Python 3.11 + openpyxl |
| Backend API | FastAPI |
| Frontend | React + Recharts |
| AI Layer | Anthropic Claude API |

---

## Database — 12 Tables

| Table | Description |
|-------|-------------|
| `divisions` | EPD, CMD, EAD, EOD, QAD, EAM, MEU, EADD |
| `units` | Sub-units per division |
| `categories` | Work categories (Bridges, Geotechnical, etc.) |
| `solicitation_types` | Task Order, Small Contracts, SBE Set-Aside... |
| `sites` | JFK, LGA, EWR, HQ, etc. |
| `firms` | All vendor firms with certifications |
| `programs` | RFPs / Agreement Lists |
| `program_firms` | Firms listed on each program |
| `awards` | Every awarded task order / contract action |
| `sub_awards` | Sub-contractor relationships and payments |
| `mbe_tracking` | MBE committed vs paid vs actual |
| `communications` | Email log per firm/program |
| `performance_letters` | Formal performance records |
| `workflows` | WF document status tracking |
| `spend_tracking` | Actual PO/invoice spend |
| `agreement_progress` | % complete per active agreement |

### Setup

```bash
# 1. Create the database
mysql -u root -p -e "CREATE DATABASE ecms;"

# 2. Load schema and mock data
mysql -u root -p ecms < database/schema.sql

# 3. Copy and configure environment
cp .env.example .env
# Edit .env with your credentials
```

---

## Project Structure

```
ecms/
├── README.md
├── .gitignore
├── .env.example              # Template — copy to .env, never commit .env
├── database/
│   ├── schema.sql            # Full schema + mock data
│   └── migrations/           # Incremental schema changes
│       └── 001_initial.sql
├── scripts/
│   └── import_excel.py       # Phase 2: Excel → MySQL
├── backend/                  # Phase 3: FastAPI API
├── frontend/                 # Phase 4: React dashboard
└── ai/                       # Phase 5: AI chat layer
```

---

## Branch Strategy

```
main                    ← stable, always deployable
dev                     ← integration branch
phase/2-excel-import
phase/3-backend
phase/4-dashboard
phase/5-ai-chat
phase/6-firm-intelligence
phase/7-workflow-integration
```

---

## Important Rules

- **Never commit `.env`** — it contains database credentials and API keys
- **Never commit real PA data** — Excel files, CSVs, or SQL dumps with real firm/contract data
- **Never commit directly to `main`** — always branch and open a pull request
- All secrets go in `.env`, all code reads from environment variables
