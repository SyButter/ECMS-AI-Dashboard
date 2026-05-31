/**
 * api.js — All calls to the FastAPI backend
 * Every function maps to one endpoint.
 * Components import from here — never call fetch/axios directly.
 */

import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

// Build query string from a filters object, dropping null/undefined values
const q = (params = {}) => {
  const clean = Object.fromEntries(
    Object.entries(params).filter(([, v]) => v !== null && v !== undefined && v !== '')
  )
  return { params: clean }
}

export const getKpis           = (filters) => api.get('/kpis',              q(filters))
export const getByType         = (filters) => api.get('/awards/by-type',    q(filters))
export const getByDivision     = (filters) => api.get('/awards/by-division',q(filters))
export const getByFirm         = (filters) => api.get('/awards/by-firm',    q(filters))
export const getBySite         = (filters) => api.get('/awards/by-site',    q(filters))
export const getTrend          = (filters) => api.get('/awards/trend',      q(filters))
export const getAwards         = (filters) => api.get('/awards',            q(filters))
export const getFilters        = ()        => api.get('/filters')

export const getPrograms       = (filters) => api.get('/programs',          q(filters))
export const getProgram        = (id)      => api.get(`/programs/${id}`)
export const getProgramFinancials = (id)   => api.get(`/programs/${id}/financials`)
export const getProgramFirms   = (id)      => api.get(`/programs/${id}/firms`)

export const getFirms          = (filters) => api.get('/firms',             q(filters))
export const getFirm           = (id)      => api.get(`/firms/${id}`)
export const getFirmAwards     = (id)      => api.get(`/firms/${id}/awards`)
export const getFirmMbe        = (id)      => api.get(`/firms/${id}/mbe`)
export const getFirmPerf       = (id)      => api.get(`/firms/${id}/performance`)
export const getFirmComms      = (id)      => api.get(`/firms/${id}/communications`)
export const getFirmProgress   = (id)      => api.get(`/firms/${id}/progress`)
export const getDuplicates     = ()        => api.get('/firms/duplicates')

export const getWorkflows      = ()        => api.get('/workflows')
export const getStuckWorkflows = ()        => api.get('/workflows/stuck')
