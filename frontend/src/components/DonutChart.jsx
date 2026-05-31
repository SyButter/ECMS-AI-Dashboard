/**
 * DonutChart — Awards by Solicitation Type
 * Matches the pie/donut in the PowerBI Summary dashboard.
 */

import { PieChart, Pie, Cell, Tooltip, Legend, ResponsiveContainer } from 'recharts'
import { useApi } from '../hooks/useApi'
import { getByType } from '../utils/api'
import { formatMoney } from '../utils/format'

const COLORS = ['#1E3A8A', '#3B82F6', '#06B6D4', '#6366F1', '#8B5CF6']

export default function DonutChart({ filters }) {
  const { data, loading } = useApi(getByType, filters)

  if (loading) return <div className="bg-slate-100 animate-pulse rounded-lg h-64" />
  if (!data?.length) return <div className="text-slate-400 text-sm p-4">No data</div>

  return (
    <div className="bg-white rounded-lg p-4 shadow-sm">
      <h3 className="text-sm font-semibold text-slate-700 mb-1">Awards Amt</h3>
      <p className="text-xs text-slate-400 mb-3">By Solicitation Type</p>
      <ResponsiveContainer width="100%" height={220}>
        <PieChart>
          <Pie
            data={data}
            dataKey="awards_amt"
            nameKey="solicitation_type"
            cx="50%"
            cy="50%"
            innerRadius={55}
            outerRadius={85}
            paddingAngle={2}
          >
            {data.map((_, i) => (
              <Cell key={i} fill={COLORS[i % COLORS.length]} />
            ))}
          </Pie>
          <Tooltip
            formatter={(val, name) => [formatMoney(val), name]}
            contentStyle={{ fontSize: 12 }}
          />
          <Legend
            iconType="circle"
            iconSize={8}
            formatter={(val) => <span style={{ fontSize: 11 }}>{val}</span>}
          />
        </PieChart>
      </ResponsiveContainer>
    </div>
  )
}
