/** Format a number as $96M, $4.2M, $450K etc. */
export const formatMoney = (val) => {
  if (val == null) return '—'
  const n = Number(val)
  if (n >= 1_000_000) return `$${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000)     return `$${(n / 1_000).toFixed(0)}K`
  return `$${n.toLocaleString()}`
}

/** Format a full dollar amount with commas: $1,234,567 */
export const formatDollar = (val) => {
  if (val == null) return '—'
  return `$${Number(val).toLocaleString()}`
}

/** Format a date string to MM/DD/YYYY */
export const formatDate = (val) => {
  if (!val) return '—'
  return new Date(val).toLocaleDateString('en-US')
}

/** Format a percentage */
export const formatPct = (val) => {
  if (val == null) return '—'
  return `${Number(val).toFixed(1)}%`
}
