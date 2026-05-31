/**
 * App.jsx — Main dashboard layout
 * Assembles all panels. Filters live here and flow down to every panel.
 * When a filter changes, every panel re-fetches with the new filter applied.
 */

import { useState } from 'react'
import FilterBar     from './components/FilterBar'
import KpiCards      from './components/KpiCards'
import DonutChart    from './components/DonutChart'
import TrendChart    from './components/TrendChart'
import SummaryTable  from './components/SummaryTable'
import { DivisionChart, FirmChart, SiteChart } from './components/BarPanels'
import AwardsTable   from './components/AwardsTable'

export default function App() {
  const [filters, setFilters] = useState({})

  return (
    <div className="min-h-screen bg-slate-100">

      {/* Header */}
      <header className="bg-blue-900 text-white px-6 py-4 flex items-center justify-between">
        <div>
          <h1 className="text-lg font-bold tracking-wide">ECMS</h1>
          <p className="text-xs text-blue-300">Engineering Contract Management System</p>
        </div>
        <div className="flex gap-6 text-xs text-blue-300">
          <span className="cursor-pointer hover:text-white font-medium text-white border-b border-white pb-0.5">
            Summary
          </span>
          <span className="cursor-pointer hover:text-white">Awarded Firms</span>
          <span className="cursor-pointer hover:text-white">Programs</span>
          <span className="cursor-pointer hover:text-white">Workflows</span>
        </div>
      </header>

      {/* Filter Bar */}
      <FilterBar filters={filters} onChange={setFilters} />

      {/* Dashboard Content */}
      <main className="px-6 py-5 space-y-5 max-w-screen-2xl mx-auto">

        {/* Row 1 — KPI Cards */}
        <KpiCards filters={filters} />

        {/* Row 2 — Donut + Summary Table */}
        <div className="grid grid-cols-1 lg:grid-cols-5 gap-4">
          <div className="lg:col-span-2">
            <DonutChart filters={filters} />
          </div>
          <div className="lg:col-span-3">
            <SummaryTable filters={filters} compareYear={filters.year ? filters.year - 1 : null} />
          </div>
        </div>

        {/* Row 3 — Trend Chart */}
        <TrendChart filters={filters} />

        {/* Row 4 — Division | Firm | Site bar charts */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <DivisionChart filters={filters} />
          <FirmChart     filters={filters} />
          <SiteChart     filters={filters} />
        </div>

        {/* Row 5 — Detailed Awards Table */}
        <AwardsTable filters={filters} />

      </main>
    </div>
  )
}
