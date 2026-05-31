/**
 * BarPanel — reusable horizontal bar chart
 * Used for: Awards by Division, Awards by Firm, Awards by Site
 */

import {
  BarChart, Bar, XAxis, YAxis, Tooltip,
  ResponsiveContainer, Cell, LabelList
} from 'recharts'
import { useApi } from '../hooks/useApi'
import { getByDivision, getByFirm, getBySite } from '../utils/api'
import { formatMoney } from '../utils/format'

const BLUE  = '#1E3A8A'
const CYAN  = '#06B6D4'

function HorizBar({ title, subtitle, data, nameKey, valueKey, color = BLUE }) {
  if (!data?.length) return <div className="text-slate-400 text-sm p-4">No data</div>

  // Truncate long names for display
  const display = data.slice(0, 8).map(d => ({
    ...d,
    _name: d[nameKey]?.length > 22 ? d[nameKey].slice(0, 22) + '…' : d[nameKey]
  }))

  return (
    <div className="bg-white rounded-lg p-4 shadow-sm h-full">
      <h3 className="text-sm font-semibold text-slate-700 mb-1">{title}</h3>
      <p className="text-xs text-slate-400 mb-3">{subtitle}</p>
      <ResponsiveContainer width="100%" height={Math.max(180, display.length * 36)}>
        <BarChart
          data={display}
          layout="vertical"
          margin={{ top: 0, right: 60, left: 0, bottom: 0 }}
        >
          <XAxis type="number" hide />
          <YAxis
            type="category"
            dataKey="_name"
            width={130}
            tick={{ fontSize: 11, fill: '#475569' }}
            tickLine={false}
            axisLine={false}
          />
          <Tooltip
            formatter={(val) => [formatMoney(val), 'Award Amount']}
            contentStyle={{ fontSize: 12 }}
          />
          <Bar dataKey={valueKey} radius={[0, 3, 3, 0]} fill={color}>
            <LabelList
              dataKey={valueKey}
              position="right"
              formatter={formatMoney}
              style={{ fontSize: 11, fill: '#475569' }}
            />
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}

export function DivisionChart({ filters }) {
  const { data, loading } = useApi(getByDivision, filters)
  if (loading) return <div className="bg-slate-100 animate-pulse rounded-lg h-56" />
  return <HorizBar title="Awards Amt" subtitle="By Division" data={data} nameKey="division_code" valueKey="awards_amt" color={BLUE} />
}

export function FirmChart({ filters }) {
  const { data, loading } = useApi(getByFirm, filters)
  if (loading) return <div className="bg-slate-100 animate-pulse rounded-lg h-56" />
  return <HorizBar title="Awards Amt" subtitle="By Awarded Firm" data={data} nameKey="awarded_firm" valueKey="awards_amt" color={CYAN} />
}

export function SiteChart({ filters }) {
  const { data, loading } = useApi(getBySite, filters)
  if (loading) return <div className="bg-slate-100 animate-pulse rounded-lg h-56" />
  return <HorizBar title="Awards Amt" subtitle="By Site" data={data} nameKey="site_name" valueKey="awards_amt" color={BLUE} />
}
