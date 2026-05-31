/**
 * AwardsTable — paginated detailed award log
 * Matches the "Detailed View" table at the bottom of the PowerBI dashboard.
 */

import { useState } from 'react'
import { useApi } from '../hooks/useApi'
import { getAwards } from '../utils/api'
import { formatDollar, formatDate } from '../utils/format'

const TH = ({ children, onClick, sorted }) => (
  <th
    onClick={onClick}
    className={`px-3 py-2 text-left text-xs font-semibold text-slate-500 uppercase
      tracking-wide whitespace-nowrap select-none
      ${onClick ? 'cursor-pointer hover:text-slate-800' : ''}`}
  >
    {children} {sorted === 'asc' ? '↑' : sorted === 'desc' ? '↓' : ''}
  </th>
)

const TD = ({ children, className = '' }) => (
  <td className={`px-3 py-2 text-sm text-slate-700 whitespace-nowrap ${className}`}>
    {children}
  </td>
)

export default function AwardsTable({ filters }) {
  const [page,    setPage]    = useState(1)
  const [sortBy,  setSortBy]  = useState('award_date')
  const [sortDir, setSortDir] = useState('desc')

  const params = { ...filters, page, page_size: 20, sort_by: sortBy, sort_dir: sortDir }
  const { data, loading } = useApi(getAwards, params)

  const handleSort = (col) => {
    if (sortBy === col) setSortDir(d => d === 'asc' ? 'desc' : 'asc')
    else { setSortBy(col); setSortDir('desc') }
    setPage(1)
  }

  const sorted = (col) => sortBy === col ? sortDir : null

  return (
    <div className="bg-white rounded-lg shadow-sm overflow-hidden">
      <div className="px-4 py-3 border-b border-slate-100">
        <h3 className="text-sm font-semibold text-slate-700">Detailed View</h3>
        {data && (
          <p className="text-xs text-slate-400 mt-0.5">
            {data.total.toLocaleString()} records
          </p>
        )}
      </div>

      <div className="overflow-x-auto">
        <table className="w-full min-w-[900px]">
          <thead className="bg-slate-50 border-b border-slate-200">
            <tr>
              <TH onClick={() => handleSort('award_date')}  sorted={sorted('award_date')}>Award Date</TH>
              <TH>Agreement No.</TH>
              <TH>Assignment</TH>
              <TH onClick={() => handleSort('awarded_firm')} sorted={sorted('awarded_firm')}>Awarded Firm</TH>
              <TH onClick={() => handleSort('division_code')} sorted={sorted('division_code')}>Division</TH>
              <TH>Site</TH>
              <TH>PO #</TH>
              <TH onClick={() => handleSort('solicitation_type')} sorted={sorted('solicitation_type')}>Type</TH>
              <TH onClick={() => handleSort('award_amount')} sorted={sorted('award_amount')}>Amt $</TH>
              <TH>Program</TH>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {loading ? (
              Array(8).fill(0).map((_, i) => (
                <tr key={i}>
                  {Array(10).fill(0).map((_, j) => (
                    <td key={j} className="px-3 py-2">
                      <div className="h-4 bg-slate-100 animate-pulse rounded" />
                    </td>
                  ))}
                </tr>
              ))
            ) : data?.data?.map((row) => (
              <tr key={row.award_id} className="hover:bg-slate-50 transition-colors">
                <TD>{formatDate(row.award_date)}</TD>
                <TD className="font-mono text-xs">{row.agreement_number || '—'}</TD>
                <TD>{row.assignment || '—'}</TD>
                <TD className="font-medium">{row.awarded_firm}</TD>
                <TD>
                  <span className="bg-blue-100 text-blue-800 text-xs px-2 py-0.5 rounded font-medium">
                    {row.division_code}
                  </span>
                </TD>
                <TD>{row.site_code || '—'}</TD>
                <TD className="font-mono text-xs">{row.po_number || '—'}</TD>
                <TD>
                  <span className={`text-xs px-2 py-0.5 rounded font-medium ${
                    row.solicitation_type === 'Task Order'      ? 'bg-blue-100 text-blue-800' :
                    row.solicitation_type === 'Small Contracts' ? 'bg-green-100 text-green-800' :
                    row.solicitation_type === 'SBE Set-Aside'   ? 'bg-cyan-100 text-cyan-800' :
                    'bg-slate-100 text-slate-700'
                  }`}>
                    {row.solicitation_type}
                  </span>
                </TD>
                <TD className="font-semibold text-right">{formatDollar(row.award_amount)}</TD>
                <TD className="max-w-[200px] truncate text-xs text-slate-500" title={row.program_title}>
                  {row.program_title}
                </TD>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      {data && data.pages > 1 && (
        <div className="px-4 py-3 border-t border-slate-100 flex items-center justify-between">
          <span className="text-xs text-slate-500">
            Page {data.page} of {data.pages}
          </span>
          <div className="flex gap-2">
            <button
              onClick={() => setPage(p => Math.max(1, p - 1))}
              disabled={page === 1}
              className="px-3 py-1 text-xs rounded border border-slate-200
                disabled:opacity-40 hover:bg-slate-50"
            >
              Previous
            </button>
            <button
              onClick={() => setPage(p => Math.min(data.pages, p + 1))}
              disabled={page === data.pages}
              className="px-3 py-1 text-xs rounded border border-slate-200
                disabled:opacity-40 hover:bg-slate-50"
            >
              Next
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
