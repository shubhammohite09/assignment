# Task Tracker – bug-fix exercise

A small full-stack app (React 18 + Vite, Spring Boot 3.2 / Java 17, H2 in-memory DB) for searching and filtering tasks. This is my submission for the technical exercise: I found and fixed the highest-value bugs and wrote up what I did.

- Written explanations: `NOTES.md` (typed summary) and the `handwritten/` folder (my handwritten notes, photos/scans).
- The original exercise brief is in `README.original.md`.

## Run it

You need Java 17+ and Node 18+.

**Quick way (Windows):** double-click `run-app.bat`. On Mac/Linux run `./run-app.sh`.

**Manually, in two terminals:**

```bash
# Terminal 1 - backend on http://localhost:8080
cd backend
./mvnw spring-boot:run        # Windows: mvnw.cmd spring-boot:run

# Terminal 2 - frontend on http://localhost:5173
cd frontend
npm install
npm run dev
```

Then open http://localhost:5173.

## What I changed

| # | Problem | Where | Fix |
|---|---------|-------|-----|
| 1 | Search SQL mixed `AND`/`OR` without brackets, so archived tasks leaked in and the status filter was ignored for title matches | `TaskRepository.java`, `db/queries/search_tasks.sql`, `db/oracle/task_search_package.sql` | Grouped `(title LIKE ... OR description LIKE ...)`; added `id DESC` as a tiebreaker for stable paging |
| 2 | Hidden `Thread.sleep` (up to 1s per request, worst for short/empty queries) | `TaskController.java` | Removed it |
| 3 | Invalid `status` or `page`/`pageSize` values caused a 500 or crash | `TaskController.java` | Return 400 for a bad status; clamp page (min 1) and page size (1–100) |
| 4 | Status filter used `:status IS NULL OR ...` in one query | `TaskRepository.java` | Split into two queries (with and without status) |
| 5 | Slow old responses could overwrite newer ones; an error left the UI stuck on "Loading…" and old errors were never cleared | `useTasks.js`, `api.js` | Abort stale requests, always reset loading, clear error on each request, removed the debug `console.log` |
| 6 | Request on every keystroke; changing search/filter could leave you on a page that no longer exists | `App.jsx` | 300 ms debounce; reset to page 1 when search or status changes |

## Assumptions and things I did not change

- Pagination still happens in Java after fetching all matches. That is fine for this data size, but a database-level `LIMIT/OFFSET` would be the next step.
- `%` and `_` typed into search are not escaped.
- CORS origin, the H2 console and `show-sql` are left as they were.
- There are no automated tests yet; adding a test for the search query would stop bug #1 coming back.

## Use of AI

I used Claude (an AI assistant) to help read the code and draft fixes, then reviewed the changes and tested them myself. Details are in `NOTES.md`.
