# VPCO — VE Technologies Co.

A Node.js/Express web application and API for VE Technologies Co., serving a static SPA frontend alongside a RESTful API backend.

## Features

- **Express API** with services, contact form, about, health-check, and Wix integration endpoints
- **SPA frontend** with smooth navigation, dynamic service cards loaded from the API, and a contact form
- **Slack notifications** for new contact form submissions (optional, via incoming webhook)
- **Azure App Service** deployment ready; environment variables sourced from App Service Application Settings

## Getting Started

### Prerequisites

- Node.js ≥ 18.0.0
- npm

### Install

```bash
npm install
```

### Configure environment

Copy `.env.example` to `.env` and fill in your values (only needed for local development when using Wix or Slack integrations):

```bash
cp .env.example .env
# edit .env with your credentials
```

> **Azure deployment**: environment variables are set in Azure App Service Application Settings — do **not** commit `.env` to git.

### Run

| Command | Description |
|---------|-------------|
| `npm start` | Start production server |
| `npm run dev` | Start development server with hot-reload (nodemon) |
| `npm test` | Run Jest test suite |

The server listens on `http://localhost:3000` by default (configurable via `PORT`).

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/services` | List all services |
| GET | `/api/services/:id` | Get a single service |
| POST | `/api/contact` | Submit a contact form |
| GET | `/api/contacts` | List contact submissions (dev only) |
| GET | `/api/about` | Company information |
| GET | `/api/wix/status` | Wix API configuration status |
| GET | `/api/wix/example` | Wix API scaffold (requires credentials) |

All responses use the envelope `{ success: boolean, data?: any, error?: string }`.

### Example: submit a contact

```bash
curl -X POST http://localhost:3000/api/contact \
  -H 'Content-Type: application/json' \
  -d '{"name":"Jane Doe","email":"jane@example.com","message":"Hello!"}'
```

## Project Structure

```
.
├── server.js          # Express app and API routes
├── index.html         # SPA entry point
├── scripts/
│   └── main.js        # Frontend JavaScript
├── styles/
│   └── main.css       # Stylesheet
├── tests/
│   └── api.test.js    # Jest + Supertest API tests
├── .env.example       # Environment variable template
├── deploy-env-to-azure.sh / .ps1   # Push .env values to Azure
├── test-deployment.sh / .ps1       # Smoke-test the live deployment
└── start-production.sh / .ps1      # Run tests then start in production
```

## Deployment

Azure App Service configuration scripts are included for convenience:

```bash
# Push local .env values to Azure App Service settings
./deploy-env-to-azure.sh

# Smoke-test the live deployment
./test-deployment.sh
```

## License

MIT © 2025 VE Technologies Co.
