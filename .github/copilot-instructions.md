# Copilot Instructions — VPCO

Purpose: Give AI coding agents the exact, discoverable knowledge needed to be immediately productive in this repository.

## Architecture Overview

**Stack**: Node.js + Express backend serving static HTML/CSS/JS frontend + Wix API integration

```
├── server.js          # Express server (port 3000, serves frontend + API + Wix proxy)
├── index.html         # Static frontend entry point
├── styles/main.css    # CSS with custom properties, responsive grid
├── scripts/main.js    # Frontend JS (fetch API calls, smooth scroll, form handling)
├── tests/api.test.js  # Jest + Supertest API tests
└── .env.example       # Environment template (copy to .env, never commit .env)
```

**Key architectural decisions**:
- Single Express server serves both static files and `/api/*` routes (no separate frontend build)
- In-memory data storage (arrays in `server.js`) — production needs real DB
- `server.js` exports `app` without starting listener when `require.main !== module` for testing
- Wix API credentials loaded from `.env` via `dotenv`, validated on startup with console warnings
- CORS enabled globally for local dev flexibility

## Development Workflow

**Setup**:
```bash
cp .env.example .env      # Create .env from template
# Edit .env with real Wix credentials
npm install
npm run dev               # Start with nodemon (auto-reload on file changes)
```

**Testing**:
```bash
npm test                  # Run Jest tests (uses supertest, no server needed)
curl http://localhost:3000/api/health
curl -X POST http://localhost:3000/api/contact -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@test.com","message":"Hi"}'
```

**CI/CD**: GitHub Actions workflows (`.github/workflows/`)
- `ci.yml` — runs tests on push/PR to `main` or `mainVPCO`
- `deploy.yml` — runs tests then triggers Render deploy hook on push to `main`/`mainVPCO`
  - Requires GitHub secrets: `RENDER_DEPLOY_HOOK_URL`, `RENDER_HEALTHCHECK_URL` (optional)
  - Polls `/api/health` for up to 5 minutes post-deploy

## API Endpoints (in `server.js`)

**Public**:
- `GET /api/health` — health check with timestamp
- `GET /api/services` — list all services
- `GET /api/services/:id` — get single service (404 if not found)
- `POST /api/contact` — submit contact form (validates email regex, stores in-memory)
- `GET /api/about` — company info

**Wix Integration**:
- `GET /api/wix/status` — check if Wix credentials are configured
- `GET /api/wix/example` — placeholder for Wix API calls (returns 503 if not configured)

**Admin** (no auth yet):
- `GET /api/contacts` — view all contact form submissions

**Adding new endpoints**: Insert route handlers in `server.js` BEFORE the `app.use('/api/*', ...)` 404 handler (~line 145). All non-API routes fall through to `index.html` for SPA-like routing.

## Frontend Conventions

**CSS** (`styles/main.css`):
- Uses CSS custom properties in `:root` — `--primary-color: #2563eb`, `--secondary-color: #1e40af`
- `.section` class for consistent padding, alternating backgrounds via `:nth-child(even)`
- Responsive grid: `.services-grid` uses `repeat(auto-fit, minmax(280px, 1fr))`

**JS** (`scripts/main.js`):
- `API_BASE_URL = window.location.origin + '/api'` — auto-adjusts for any domain
- `loadServices()` called on page load, populates `.services-grid` from `/api/services`
- Contact form: disables submit button during POST, shows "Sending..." state, uses `alert()` for feedback
- Smooth scroll: `scrollIntoView({behavior: 'smooth'})` on `#anchor` links
- Active nav state: `updateActiveNav()` on scroll, adds `.active` class to current section link

## Environment Variables (.env)

**Required for Wix integration**:
- `WIX_API_KEY`, `WIX_API_TOKEN`, `WIX_SITE_ID`, `WIX_ACCOUNT_ID`, `DOMAIN_NAME`

**Optional**:
- `PORT` (default 3000), `NODE_ENV` (default development)

**Never commit `.env`** — it's git-ignored. Copy from `.env.example` and fill real values.

## Testing

**Run tests**: `npm test` (Jest with `--runInBand` to avoid port conflicts)

**Test patterns** (`tests/api.test.js`):
- Uses `supertest(app)` — no need to start server manually
- Tests import `app` from `server.js` (exports without listening)
- Covers: health check, services CRUD, contact form validation (email regex, required fields), HTML serving, 404 handling, Wix status

**Add new tests**: Follow existing pattern in `api.test.js`, use `expect(res.body).toHaveProperty('success', true)` for API responses

## Common Tasks

**Add API endpoint**:
1. Add route in `server.js` before 404 handler (e.g., `app.get('/api/newroute', (req, res) => { ... })`)
2. Add test in `tests/api.test.js`
3. Run `npm test` to verify
4. Update `README.md` if user-facing

**Add frontend section**:
1. Add `<section id="newsection" class="section">` in `index.html`
2. Add styles in `styles/main.css` (reuse `.section`, `.container`)
3. Add nav link: `<li><a href="#newsection">New</a></li>`

**Connect API to frontend**:
1. Add `async function` in `scripts/main.js` with `fetch(API_BASE_URL + '/endpoint')`
2. Call on page load (`window.addEventListener('load', ...)`) or user interaction

## Wix Integration

**DNS**: Domain uses Wix nameservers (`ns6.wixdns.net`, `ns7.wixdns.net`) — all DNS changes in Wix DNS Manager, not NS records. See `DNS_SETUP.md` for Render deploy configuration.

**Wix API calls**: Add in `/api/wix/*` routes in `server.js`, use `WIX_CONFIG` object (loaded from `.env`). Example placeholder at `GET /api/wix/example` shows pattern.

## Deployment (Render)

**Setup**:
1. Push to GitHub
2. Create Render Web Service, point to repo
3. Set env vars in Render dashboard (all from `.env.example`)
4. Build: `npm install`, Start: `npm start`
5. Add custom domain in Render, configure DNS in Wix Manager (see `DNS_SETUP.md`)

**Deploy hook**: `.github/workflows/deploy.yml` auto-deploys on push to `main`/`mainVPCO` after tests pass

## Repository Conventions

- Branches: `main` or `mainVPCO` (both trigger CI/CD)
- Owner: VETechnologiesCo
- Commit style: `feat(api): add user endpoint`, `fix(ui): correct form validation`
- Dependencies: Minimal by design — verify necessity before adding packages
- Data storage: In-memory arrays — production needs PostgreSQL/MongoDB + auth for `/api/contacts`

## Quick Reference

- **Start dev**: `npm run dev`
- **Test**: `npm test`
- **Health check**: `curl http://localhost:3000/api/health`
- **Route definitions**: `server.js` lines 40-145
- **Test specs**: `tests/api.test.js`
- **Env template**: `.env.example` (copy to `.env`)
