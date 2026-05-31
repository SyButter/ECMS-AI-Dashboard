"""
main.py — ECMS FastAPI Application
=====================================
Entry point for the backend API server.

Start the server:
  cd backend
  uvicorn main:app --reload --port 8000

API docs (auto-generated):
  http://localhost:8000/docs       ← Swagger UI
  http://localhost:8000/redoc      ← ReDoc

All endpoints are prefixed with /api
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from backend.routers import dashboard, programs, firms, workflows

app = FastAPI(
    title="ECMS API",
    description="Engineering Contract Management System — Backend API",
    version="0.1.0",
)

# ---------------------------------------------------------------------------
# CORS — allows the React frontend (localhost:3000) to call this API.
# In production, replace * with the actual frontend domain.
# ---------------------------------------------------------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------------------------
# Routers — each file handles one domain
# ---------------------------------------------------------------------------
app.include_router(dashboard.router)
app.include_router(programs.router)
app.include_router(firms.router)
app.include_router(workflows.router)


# ---------------------------------------------------------------------------
# Health check
# ---------------------------------------------------------------------------
@app.get("/health")
def health():
    return {"status": "ok", "service": "ECMS API"}


@app.get("/")
def root():
    return {
        "service": "ECMS API",
        "version": "0.1.0",
        "docs":    "/docs",
    }
