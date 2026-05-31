/**
 * SummaryTable — Awards by Solicitation Type with year comparison
 * Matches the summary grid in the top right of the PowerBI dashboard.
 */

import { useApi } from '../hooks/useApi'
import { getByType } from '../utils/api'
import { formatDollar, formatPct } from '../utils/format'

export default function SummaryTable({ filters, compareYear }) {
  const { data: current } = useApi(getByType, filters)
  const { data: compare } = useApi(getByType, compareYear ? { ...filters, year: compareYear } : null)

  const rows = [
    { label: 'Task Order',      key: 'Task Order' },
    { label: 'Small Contracts', key: 'Small Contracts' },
    { label: 'SBE Set-Aside',   key: 'SBE Set-Aside' },
  ]

  const find = (arr, key) => arr?.find(r => r.solicitation_type === key) || {}

  const totalAmt     = current?.reduce((s, r) => s + Number(r.awards_amt), 0) || 0
  const totalCount   = current?.reduce((s, r) => s + Number(r.num_awards), 0) || 0
  const cmpTotalAmt  = compare?.reduce((s, r) => s + Number(r.awards_amt), 0) || 0
  const cmpTotalCount= compare?.reduce((s, r) => s + Number(r.num_awards), 0) || 0

  const thClass = 'px-3 py-2 text-xs font-semibold text-blue-700 text-right border-b border-blue-100'
  const tdClass = 'px-3 py-2 text-sm text-slate-700 text-right'
  const rowClass = 'border-b border-slate-100 hover:bg-slate-50'

  return (
    <div className="bg-white rounded-lg shadow-sm overflow-hidden">
      <div className="px-4 py-3 border-b border-slate-100">
        <h3 className="text-sm font-semibold text-slate-700">Summary</h3>
        <p className="text-xs text-slate-400">By Solicitation Type</p>
      </div>
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead className="bg-blue-50">
            <tr>
              <th className="px-3 py-2 text-xs font-semibold text-blue-700 text-left border-b border-blue-100">
                Solicitation Type
              </th>
              <th className={thClass}>Awards Amt</th>
              <th className={thClass}>Amt %</th>
              <th className={thClass}># Awards</th>
              {compare && <>
                <th className={thClass}>Prior Amt</th>
                <th className={thClass}>Prior %</th>
                <th className={thClass}>Prior #</th>
              </>}
            </tr>
          </thead>
          <tbody>
            {rows.map(({ label, key }) => {
              const cur = find(current, key)
              const cmp = find(compare, key)
              return (
                <tr key={key} className={rowClass}>
                  <td className="px-3 py-2 text-sm text-slate-700 font-medium">{label}</td>
                  <td className={tdClass}>{cur.awards_amt ? formatDollar(cur.awards_amt) : '—'}</td>
                  <td className={tdClass}>{cur.pct ? formatPct(cur.pct) : '—'}</td>
                  <td className={tdClass}>{cur.num_awards || '—'}</td>
                  {compare && <>
                    <td className={tdClass}>{cmp.awards_amt ? formatDollar(cmp.awards_amt) : '—'}</td>
                    <td className={tdClass}>{cmp.pct ? formatPct(cmp.pct) : '—'}</td>
                    <td className={tdClass}>{cmp.num_awards || '—'}</td>
                  </>}
                </tr>
              )
            })}
          </tbody>
          <tfoot>
            <tr className="bg-blue-800 text-white font-semibold">
              <td className="px-3 py-2 text-sm">Total</td>
              <td className="px-3 py-2 text-sm text-right">{formatDollar(totalAmt)}</td>
              <td className="px-3 py-2 text-sm text-right">100%</td>
              <td className="px-3 py-2 text-sm text-right">{totalCount}</td>
              {compare && <>
                <td className="px-3 py-2 text-sm text-right">{formatDollar(cmpTotalAmt)}</td>
                <td className="px-3 py-2 text-sm text-right">100%</td>
                <td className="px-3 py-2 text-sm text-right">{cmpTotalCount}</td>
              </>}
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  )
}
