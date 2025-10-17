# Quick Start: Adding Your Wix Credentials

## ⚠️ IMPORTANT: Security First!

**DO NOT paste your API keys in chat, email, or any public place!**

## Step-by-Step Guide

### 1️⃣ Create your `.env` file

In the terminal, run:

```bash
cp .env.example .env
```

### 2️⃣ Open `.env` file in VS Code

Click on `.env` in the file explorer (or use Command/Ctrl+P and type `.env`)

### 3️⃣ Replace the placeholder values

Your `.env` file should look like this (with YOUR actual credentials):

```env
PORT=3000
NODE_ENV=development

cp .env.example .env
WIX_API_KEY=your_actual_key_heref0e7a4bc-9763-47bb-bdc9-d7c1413612ad
WIX_API_TOKEN=IST.eyJraWQiOiJQb3pIX2FDMiIsImFsZyI6IlJTMjU2In0.eyJkYXRhIjoie1wiaWRcIjpcIjVjNzYwMjgyLWQ2NWQtNGQ1OS04OGFhLWM0YWY1NGNjZDNkMFwiLFwiaWRlbnRpdHlcIjp7XCJ0eXBlXCI6XCJhcHBsaWNhdGlvblwiLFwiaWRcIjpcIjUxNmI5N2I3LTdlZjYtNGM0NC04NWY5LWM2Y2YzOGViNzU2N1wifSxcInRlbmFudFwiOntcInR5cGVcIjpcImFjY291bnRcIixcImlkXCI6XCJmMGU3YTRiYy05NzYzLTQ3YmItYmRjOS1kN2MxNDEzNjEyYWRcIn19IiwiaWF0IjoxNzYwNjc2OTkxfQ.D7VWtdcoLKYSjjyRWpDL7ZyEwBy9hICjv6xP53mWrJo4eimjdZD6LqtOder2SZ5YDpwO7wOMRunPxBH9sVqzcHnPVb16tnfSjg_i7aSdn6mJRPw2JjGpSQ4J43qE_7ZsF-Npt9H54p9E4wy_6XoLiXc-LJcCVcsQsO0XcRTjzCkaXvwHEhkefw5h_r1JUhcZBh0G7A7tERXh6_iH_xU7fZnBAjZZ1Tcssf50sWhNX0GUz1TbOHvwUkPLxbQ_UMyZ5QbhFpJ-YHP2_5bmn7CDh_-lLi5yflum0hua8xgEFrub4cdKEg5WPAHV4esRF6AcHYc35ugBzPp_ZeFRKy1Bsg
WIX_SITE_ID=VECO
WIX_ACCOUNT_ID=vetechnologiesco@gmail.com

DOMAIN_NAME=vigliottaproperties.com
```

### 4️⃣ Save the file (Ctrl+S / Cmd+S)

### 5️⃣ Restart the server

```bash
npm start
```

You should see:
```
✅ Wix API credentials loaded
🚀 VPCO API Server running on http://localhost:3000
```

### 6️⃣ Verify it worked

```bash
curl http://localhost:3000/api/wix/status
```

Should return:
```json
{
  "success": true,
  "data": {
    "configured": true,
    "hasApiKey": true,
    "hasApiToken": true,
    ...
  }
}
```

## ✅ That's it!

Your Wix credentials are now:
- ✅ Loaded securely from `.env`
- ✅ NOT committed to git (`.gitignore` protects it)
- ✅ Available to all server-side code via `WIX_CONFIG` object

## 🔧 Where to Find Your Wix Credentials

1. **Wix Dashboard** → Settings → API Keys
2. **Or visit**: https://manage.wix.com/account/api-keys

## 📝 Next Steps

After adding credentials, you can:
- Use `WIX_CONFIG.apiKey` and `WIX_CONFIG.apiToken` in server code
- Make API calls to Wix services
- Integrate with your custom domain

See `WIX_SETUP.md` for detailed integration examples.

## ❓ Troubleshooting

**Still seeing warning?**
- Check `.env` file exists in project root (not in subfolder)
- Verify no typos in variable names
- Make sure no spaces around `=` signs
- Restart the server after editing

**Need help with Wix API integration?**
- Ask me specific questions about which Wix APIs you want to use
- I can help add endpoints for domain management, site data, etc.
