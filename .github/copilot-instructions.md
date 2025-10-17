# VPCO code generation guide for AI agents

Purpose: Give you the context to work productively in this repo without guesswork. Keep changes small, follow the patterns below, and cite files you mirror.

## Architecture
- Stack: Node.js (>=18) Express API + static SPA.
- Entry: `server.js` exports the Express `app` and only starts the server when run directly. Static assets are served from repo root.
- SPA routing: Non-`/api/*` paths serve `index.html` (catch-all). Don’t add API routes that shadow static paths.
- Response shape: `{ success: boolean, data?: any, error?: string }` across all API routes.

Key routes in `server.js` (use as patterns):
- GET `/api/health` → `{success:true,data:{status:'ok',timestamp}}`
- GET `/api/services`, GET `/api/services/:id` (in-memory catalog)
- POST `/api/contact` → validates `{name,email,message}`, stores in memory, optional Slack notify
- GET `/api/contacts` → returns in-memory submissions (dev-only)
- GET `/api/about` → static org metadata
- GET `/api/wix/status` → config flags; `/api/wix/example` → scaffold

## Environment & integrations
- No dotenv at runtime; config comes from Azure App Service. For local work export env vars in your shell:
  `WIX_API_KEY, WIX_API_TOKEN, WIX_SITE_ID, WIX_ACCOUNT_ID, DOMAIN_NAME, SLACK_WEBHOOK_URL`.
- Use `deploy-env-to-azure.sh|.ps1` to push `.env` values to Azure.
- Node 18+ global `fetch` is used for Slack; don’t add `node-fetch`.

## Conventions
- Keep the envelope consistent; validation errors are HTTP 400 with `{ success:false, error:"message" }` (see email regex in `/api/contact`).
- Mount new endpoints under `/api/...`; leave the `/api/*` 404 handler intact. Keep `module.exports = app;` for tests.
- Frontend uses `API_BASE_URL = window.location.origin + '/api'` (`scripts/main.js`).

## Developer workflows
- Install: `npm install`
- Dev server: `npm run dev` (nodemon)
- Tests: `npm test` (Jest + Supertest; see `tests/api.test.js`)
- Local prod: `./start-production.sh` (runs tests, then `NODE_ENV=production npm start`)
- Azure checks: `./test-deployment.sh` hits `https://vpco-prod.azurewebsites.net`; Slack: `./test-slack.sh` posts a sample contact (uses `jq`).

## Adding features (copy these patterns)
- API success: `res.json({ success: true, data })`
- API error: `return res.status(400).json({ success: false, error: 'Reason' })`
- Frontend fetch: mirror `loadServices()` in `scripts/main.js` and use `API_BASE_URL`.

## Files to know
- `server.js` — API routes, static serving, Slack/Wix stubs
- `index.html`, `scripts/main.js`, `styles/main.css` — SPA UI and API usage
- `tests/api.test.js` — canonical endpoint tests
- `deploy-env-to-azure.*`, `test-deployment.*`, `test-slack.*`, `start-production.*` — deployment/testing workflows

Note: There is no database; state is in-memory. Treat `/api/contacts` as development-only. If introducing persistence/auth, keep the envelope and add tests accordingly.
