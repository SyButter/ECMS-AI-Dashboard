/**
 * FilterBar — the top filter strip matching the PowerBI dashboard
 * Dropdowns: Period (year), Division, Solicitation Type, Awarded Firm
 * All filters are passed up to the parent (App) which re-fetches all panels.
 */

import { useApi } from '../hooks/useApi'
import { getFilters } from '../utils/api'

export default function FilterBar({ filters, onChange }) {
  const { data } = useApi(getFilters)

  const handle = (key) => (e) => {
    onChange({ ...filters, [key]: e.target.value || null })
  }

  const clear = () => onChange({})

  const selectClass =
    'border border-slate-300 rounded px-3 py-1.5 text-sm bg-white ' +
    'focus:outline-none focus:ring-2 focus:ring-blue-500 min-w-[140px]'

  return (
    <div className="bg-white border-b border-slate-200 px-6 py-3 flex flex-wrap items-center gap-3">

      {/* Period */}
      <div className="flex items-center gap-2">
        <label className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Period</label>
        <select className={selectClass} value={filters.year || ''} onChange={handle('year')}>
          <option value="">All</option>
          {data?.years?.map(y => <option key={y} value={y}>{y}</option>)}
        </select>
      </div>

      {/* Division */}
      <div className="flex items-center gap-2">
        <label className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Division</label>
        <select className={selectClass} value={filters.division || ''} onChange={handle('division')}>
          <option value="">All</option>
          {data?.divisions?.map(d => <option key={d} value={d}>{d}</option>)}
        </select>
      </div>

      {/* Solicitation Type */}
      <div className="flex items-center gap-2">
        <label className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Type</label>
        <select className={selectClass} value={filters.solicitation || ''} onChange={handle('solicitation')}>
          <option value="">All</option>
          {data?.solicitation_types?.map(s => <option key={s} value={s}>{s}</option>)}
        </select>
      </div>

      {/* Awarded Firm */}
      <div className="flex items-center gap-2">
        <label className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Firm</label>
        <select className={selectClass} value={filters.firm || ''} onChange={handle('firm')}>
          <option value="">All</option>
          {data?.firms?.map(f => <option key={f} value={f}>{f}</option>)}
        </select>
      </div>

      {/* Site */}
      <div className="flex items-center gap-2">
        <label className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Site</label>
        <select className={selectClass} value={filters.site || ''} onChange={handle('site')}>
          <option value="">All</option>
          {data?.sites?.map(s => <option key={s} value={s}>{s}</option>)}
        </select>
      </div>

      {/* Clear */}
      {Object.values(filters).some(Boolean) && (
        <button
          onClick={clear}
          className="ml-auto text-xs text-blue-600 hover:text-blue-800 font-medium underline"
        >
          Clear filters
        </button>
      )}
    </div>
  )
}
