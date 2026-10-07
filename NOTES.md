# NOTES

## Summary of changes
- **Search SQL precedence bug** (repository query, `db/queries/search_tasks.sql`, Oracle package count + cursor): `A AND B OR C AND D` was parsed as `(A AND B) OR (C AND D)`. Archived tasks leaked in via description matches and the status filter was ignored for title matches. Wrapped the title/description `OR` in parentheses. Added `id DESC` tiebreaker for stable paging.
- **Removed `Thread.sleep` in controller** (up to 1s per request for short queries, including empty).
- **Controller validation**: bad `status` now returns 400 (was 500); `page`/`pageSize` clamped (negative index crash, unbounded page size).
- **Frontend hook**: abort stale requests (race condition), clear error on new request, always reset `loading` (an error left the UI on "Loading..." forever).
- **Search debounce (300ms)** and **reset to page 1** when query/status change.

## Not changed
- In-memory pagination (loads all matches, then `subList`): fine for this data size, but a bigger refactor to DB-level paging that I could not run here.
- `%`/`_` not escaped in LIKE terms, hardcoded CORS, H2 console, `show-sql`.

## Biggest remaining risk
Pagination done in Java after fetching every row; it will not scale. No tests either, so the AND/OR bug could regress.

## Tools / AI used
TODO: edit this to be true. e.g. "Used Claude to read the repo and draft the fixes; I verified the SQL change against the seed data and reviewed each diff myself."
