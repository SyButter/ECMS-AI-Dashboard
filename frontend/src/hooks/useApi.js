/**
 * useApi — generic data fetching hook
 *
 * Usage:
 *   const { data, loading, error } = useApi(getKpis, filters)
 *
 * Re-fetches whenever `filters` changes.
 * `apiFn` is any function from utils/api.js
 * `args` is spread as arguments to apiFn
 */

import { useState, useEffect, useCallback } from 'react'

export function useApi(apiFn, ...args) {
  const [data,    setData]    = useState(null)
  const [loading, setLoading] = useState(true)
  const [error,   setError]   = useState(null)

  // Serialize args so useEffect dependency works correctly
  const key = JSON.stringify(args)

  const fetch = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      const res = await apiFn(...args)
      setData(res.data)
    } catch (e) {
      setError(e.message || 'Request failed')
    } finally {
      setLoading(false)
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [key])

  useEffect(() => { fetch() }, [fetch])

  return { data, loading, error, refetch: fetch }
}
