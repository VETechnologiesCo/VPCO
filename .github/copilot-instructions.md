# Copilot instructions — VPCO

Purpose: give an AI coding agent the exact, discoverable knowledge needed to be productive in this repository immediately.

## 1) Architecture Overview

**Stack**: Node.js + Express API backend serving static HTML/CSS/JS frontend

```
├── server.js          # Express API (port 3000, serves frontend + API routes)
├── index.html         # Static frontend entry point
├── styles/main.css    # CSS with custom properties, responsive grid
├── scripts/main.js    # Frontend JS (fetch API calls, smooth scroll, form handling)
└── package.json       # Node dependencies: express, cors, nodemon
```

**Key architectural decisions**:
- Single Express server serves both frontend (static files) and API (`/api/*` routes)
- In-memory data storage (arrays in `server.js`) — replace with DB for production
- Frontend calls backend via `fetch()` to `/api` endpoints
- CORS enabled for local dev flexibility

## 2) Development Workflow

**Install & run**:
```bash
npm install
npm start          # Start server on port 3000
npm run dev        # Start with nodemon (auto-reload)
```

**Testing API manually**:
```bash
curl http://localhost:3000/api/health
curl http://localhost:3000/api/services
curl -X POST http://localhost:3000/api/contact -H "Content-Type: application/json" -d '{"name":"Test","email":"test@test.com","message":"Hi"}'
```

## 3) API Endpoints (in `server.js`)

- `GET /api/health` — health check
- `GET /api/services` — list all services
- `GET /api/services/:id` — get single service
- `POST /api/contact` — submit contact form (body: `{name, email, message}`)
- `GET /api/contacts` — admin view of all submissions (no auth yet)
- `GET /api/about` — company info

**Adding new endpoints**: Add route handlers in `server.js` before the `app.use('/api/*', ...)` 404 handler.

## 4) Frontend Conventions

- **CSS**: Uses CSS custom properties (`--primary-color`, `--secondary-color`) in `:root` — update there for theme changes
- **JS**: All API calls use `fetch()` with `API_BASE_URL` constant — update if API moves to separate domain
- **Forms**: Contact form validates and sends JSON to `/api/contact`, shows alert on success/error
- **Navigation**: Smooth scroll via `scrollIntoView({behavior: 'smooth'})` on `#anchor` links

## 5) Project-Specific Patterns

- Services are loaded dynamically from API on page load (`loadServices()` in `scripts/main.js`)
- Form submission disables button and shows "Sending..." state to prevent double-submit
- Static files served from root by Express (`app.use(express.static(__dirname))`)
- All non-API routes fall through to `index.html` for SPA-like behavior

## 6) Common Tasks

**Add a new API endpoint**:
1. Add route in `server.js` (e.g., `app.get('/api/newroute', (req, res) => { ... })`)
2. Update `README.md` API section
3. Test with `curl` before frontend integration

**Add a new frontend section**:
1. Add HTML in `index.html` as `<section id="newsection">`
2. Add styles in `styles/main.css` (use `.section` class)
3. Add nav link: `<li><a href="#newsection">New</a></li>`

**Connect new API to frontend**:
1. Add `async function` in `scripts/main.js` with `fetch(API_BASE_URL + '/endpoint')`
2. Call it in `window.addEventListener('load', ...)` or on user interaction

## 7) Repository Conventions

- Branch: `main`, Owner: VETechnologiesCo
- Commit style: `feat(api): add user endpoint` or `fix(ui): correct form validation`
- Dependencies: Minimal by design — ask before adding large packages
- No database yet — data stored in-memory arrays in `server.js`

## 8) Production Readiness Checklist (not yet done)

- [ ] Replace in-memory storage with real database
- [ ] Add authentication to admin endpoints (`/api/contacts`)
- [ ] Add rate limiting (e.g., `express-rate-limit`)
- [ ] Environment variables for secrets (`.env` file + `dotenv`)
- [ ] Add tests (Jest or Mocha)
- [ ] Set up CI/CD in `.github/workflows/`

## 9) Quick Reference

**Start dev environment**: `npm run dev`  
**Check API health**: `curl http://localhost:3000/api/health`  
**View logs**: Server logs to console, check terminal output  
**Find route definitions**: All in `server.js` lines 20-80
