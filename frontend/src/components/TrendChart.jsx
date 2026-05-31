/**
 * TrendChart — Awards Amt by Fiscal Quarter
 * Matches the large bar chart in the middle of the PowerBI dashboard.
 */

import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, LabelList
} from 'recharts'
import { useApi } from '../hooks/useApi'
import { getTrend } from '../utils/api'
import { formatMoney } from '../utils/format'

const CustomLabel = ({ x, y, width, value, count }) => (
  <text x={x + width / 2} y={y - 6} fill="#475569" fontSize={10} textAnchor="middle">
    #{count} | {formatMoney(value)}
  </text>
)

export default function TrendChart({ filters }) {
  const { data, loading } = useApi(getTrend, filters)

  if (loading) return <div className="bg-slate-100 animate-pulse rounded-lg h-64" />
  if (!data?.length) return <div className="text-slate-400 text-sm p-4">No data</div>

  return (
    <div className="bg-white rounded-lg p-4 shadow-sm">
      <h3 className="text-sm font-semibold text-slate-700 mb-1">Awards Amt | Trend View</h3>
      <p className="text-xs text-slate-400 mb-3">By Fiscal Quarter</p>
      <ResponsiveContainer width="100%" height={260}>
        <BarChart data={data} margin={{ top: 24, right: 16, left: 0, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#F1F5F9" />
          <XAxis
            dataKey="fiscal_period"
            tick={{ fontSize: 10, fill: '#64748B' }}
            tickLine={false}
          />
          <YAxis
            tickFormatter={formatMoney}
            tick={{ fontSize: 10, fill: '#64748B' }}
            tickLine={false}
            axisLine={false}
            width={55}
          />
          <Tooltip
            formatter={(val) => [formatMoney(val), 'Award Amount']}
            contentStyle={{ fontSize: 12 }}
          />
          <Bar dataKey="total_amt" fill="#1E3A8A" radius={[3, 3, 0, 0]}>
            <LabelList
              content={(props) => (
                <CustomLabel {...props} count={
                  data.find(d => d.fiscal_period === props.value)?.num_awards ?? ''
                } />
              )}
            />
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}
