/**
 * KpiCards — the four header metric cards
 * Matches the PowerBI dashboard top row:
 *   Award Amt ($) | # Awards | Task Order | Small Contracts | SBE Set-Aside
 */

import { useApi } from '../hooks/useApi'
import { getKpis } from '../utils/api'
import { formatMoney } from '../utils/format'

function Card({ label, value, sub, color = 'blue' }) {
  const colors = {
    blue:  'bg-blue-800  text-white',
    light: 'bg-blue-600  text-white',
    cyan:  'bg-cyan-500  text-white',
  }
  return (
    <div className={`rounded-lg px-5 py-4 flex flex-col gap-1 ${colors[color]}`}>
      <span className="text-xs font-semibold uppercase tracking-wide opacity-80">{label}</span>
      <span className="text-2xl font-bold">{value}</span>
      {sub && <span className="text-xs opacity-70">{sub}</span>}
    </div>
  )
}

export default function KpiCards({ filters }) {
  const { data, loading } = useApi(getKpis, filters)

  if (loading) return (
    <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
      {Array(5).fill(0).map((_, i) => (
        <div key={i} className="bg-slate-200 animate-pulse rounded-lg h-20" />
      ))}
    </div>
  )

  if (!data) return null

  return (
    <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
      <Card
        label="Award Amt ($)"
        value={formatMoney(data.total_award_amt)}
        sub={`${data.total_awards} awards`}
        color="blue"
      />
      <Card
        label="# Awards"
        value={data.total_awards}
        color="blue"
      />
      <Card
        label="Task Order"
        value={`# ${data.task_order_count} | ${formatMoney(data.task_order_amt)}`}
        color="light"
      />
      <Card
        label="Small Contracts"
        value={`# ${data.small_contracts_count} | ${formatMoney(data.small_contracts_amt)}`}
        color="light"
      />
      <Card
        label="SBE Set-Aside"
        value={`# ${data.sbe_count} | ${formatMoney(data.sbe_amt)}`}
        color="cyan"
      />
    </div>
  )
}
