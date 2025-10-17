# Wix API Integration Setup

## How to Add Your Wix Credentials

### Step 1: Create `.env` file
Copy the example file and add your real credentials:

```bash
cp .env.example .env
```

### Step 2: Edit `.env` with your credentials
Open `.env` in your editor and replace the placeholder values:

```env
WIX_API_KEY=your_actual_wix_api_key
WIX_API_TOKEN=your_actual_wix_token
WIX_SITE_ID=your_wix_site_id
WIX_ACCOUNT_ID=your_wix_account_id
DOMAIN_NAME=yourdomain.com
```

### Step 3: Restart the server
```bash
npm start
```

The server will automatically load your credentials and confirm with:
```
✅ Wix API credentials loaded
```

## Security Notes

- **Never commit `.env` to git** (already in `.gitignore`)
- **Never share `.env` file** with anyone
- **Never paste credentials in chat or public places**
- `.env.example` is safe to commit (contains no real credentials)

## Where to Find Wix Credentials

1. **API Key & Token**: 
   - Go to Wix Dashboard → Settings → API Keys
   - Or: https://manage.wix.com/account/api-keys

2. **Site ID**:
   - Found in your Wix site URL or dashboard

3. **Account ID**:
   - Available in account settings

## Using Wix Credentials in Code

The server automatically loads credentials into `WIX_CONFIG` object:

```javascript
// Example: Using Wix API in server.js
app.get('/api/wix-data', async (req, res) => {
    const headers = {
        'Authorization': WIX_CONFIG.apiToken,
        'wix-api-key': WIX_CONFIG.apiKey
    };
    
    // Make Wix API calls here
});
```

## Troubleshooting

If you see `⚠️ Wix API credentials not found`:
1. Check that `.env` file exists in project root
2. Verify variable names match `.env.example`
3. Restart the server after editing `.env`
4. Make sure no spaces around `=` in `.env` file
