# VPCO

**VE Technologies Co. - Website and API**

A modern web application with a static HTML frontend and Express.js REST API backend.

## Project Structure

```
/
├── index.html          # Main HTML page
├── styles/
│   └── main.css       # Stylesheet
├── scripts/
│   └── main.js        # Frontend JavaScript (API integration)
├── server.js          # Express API server
├── package.json       # Node.js dependencies
└── README.md          # This file
```

## Features

- **Frontend**: Responsive HTML/CSS/JS website with smooth scrolling, navigation, and contact form
- **Backend API**: RESTful API with Express.js
  - `/api/health` - Health check endpoint
  - `/api/services` - Get all services
  - `/api/services/:id` - Get single service
  - `/api/contact` - Submit contact form (POST)
  - `/api/contacts` - Get all submissions (admin)
  - `/api/about` - Company information

## Quick Start

### Prerequisites
- Node.js 18+ installed

### Installation

```bash
# Install dependencies
npm install
```

### Development

```bash
# Start the server (includes frontend and API)
npm start

# Or use nodemon for auto-reload during development
npm run dev
```

The application will be available at:
- Frontend: http://localhost:3000
- API: http://localhost:3000/api

### Testing API Endpoints

```bash
# Health check
curl http://localhost:3000/api/health

# Get services
curl http://localhost:3000/api/services

# Submit contact form
curl -X POST http://localhost:3000/api/contact \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","message":"Hello!"}'

# Get company info
curl http://localhost:3000/api/about
## Testing

Run the automated test suite (Jest + Supertest):

```bash
npm test
```

This runs fast API and HTML serving checks. CI runs the same on every push/PR.
```

## Environment Variables

Create a `.env` file from `.env.example`:

```bash
cp .env.example .env
```

Edit `.env` with your actual values:
- `PORT` - Server port (default: 3000)
- `WIX_API_KEY` - Your Wix API key
- `WIX_API_TOKEN` - Your Wix API token
- `WIX_SITE_ID` - Your Wix site ID
- `WIX_ACCOUNT_ID` - Your Wix account ID
- `DOMAIN_NAME` - Your custom domain

**See [WIX_SETUP.md](./WIX_SETUP.md) for detailed Wix integration instructions.**

Example:
```bash
PORT=8080 npm start
```

## Production Deployment

For production, consider:
1. Add a proper database (PostgreSQL, MongoDB, etc.)
2. Implement authentication for admin endpoints
3. Add rate limiting and security middleware
4. Use environment variables for sensitive config
5. Set up logging and monitoring
6. Add HTTPS/TLS certificates

## Deployment (Render + Custom Domain)

You can deploy this app as a single Node.js web service on Render and connect your custom domain.

### 1) Prepare repo

- Ensure your code is pushed to GitHub
- Do NOT commit `.env` (already git-ignored)

### 2) Create Render service

- Create an account at https://render.com
- Click New → Web Service → “Build and deploy from a Git repo”
- Select this repo
- Use the following settings:
  - Runtime: Node
  - Build Command: `npm install`
  - Start Command: `npm start`
  - Environment: add your `.env` values:
    - `PORT=3000`
    - `WIX_API_KEY`, `WIX_API_TOKEN`, `WIX_SITE_ID`, `WIX_ACCOUNT_ID`, `DOMAIN_NAME`
- (Optional) Commit `render.yaml` for IaC deployment

### 3) Add custom domain

- In Render → Service → Settings → Custom Domains → Add Domain
- Add both apex (e.g., `yourdomain.com`) and `www.yourdomain.com`
- Render will show the exact DNS records required

### 4) Update DNS at your registrar (Wix)

- In Wix → Domains → Manage DNS (Advanced Settings)
- Add records as directed by Render (values may differ; follow dashboard):
  - CNAME: `www` → your Render domain (e.g., `vpco.onrender.com`)
  - Apex/root (`@`): set A/ALIAS per Render’s instructions
- Save DNS changes and wait for propagation (usually 5–60 minutes)

### 5) Verify

- Visit `https://yourdomain.com/api/health`
- Confirm the site is live and API responds

Notes:
- Keep secrets in the Render dashboard (never commit to git)
- If using another host (Railway/Fly/Azure), replicate the same env vars and start command

## License

MIT - VE Technologies Co.