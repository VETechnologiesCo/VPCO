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

WIX_API_KEY=your_wix_api_key_here
WIX_API_TOKEN=your_wix_api_token_here
WIX_SITE_ID=your_wix_site_id_here
WIX_ACCOUNT_ID=your_wix_account_id_here

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
