# 🚀 Quick Start: Make vigliottaproperties.com Live

**Goal**: Get your VPCO site live at https://vigliottaproperties.com in ~30 minutes

---

## Prerequisites ✅

Your code is ready to deploy:
- ✅ All tests passing (9/9)
- ✅ Environment variables configured
- ✅ Wix API credentials set
- ✅ Slack notifications working
- ✅ Modern design implemented

---

## 3-Step Process

### Step 1: Deploy to Render (10 minutes)

#### 1.1 Create Render Account
1. Go to https://render.com
2. Click "Get Started" → Sign in with GitHub
3. Authorize Render to access your repos

#### 1.2 Create Web Service
1. Click **"New +"** → **"Web Service"**
2. Select repository: **`VETechnologiesCo/VPCO`**
3. Configure:
   ```
   Name: vpco
   Branch: main (or mainVPCO)
   Runtime: Node
   Build Command: npm install
   Start Command: npm start
   ```

#### 1.3 Add Environment Variables
Click "Advanced" and add these (from your `.env` file):

```bash
PORT=3000
NODE_ENV=production
WIX_API_KEY=f0e7a4bc-9763-47bb-bdc9-d7c1413612ad
WIX_API_TOKEN=eyJraWQiOiJQb3pIX2FDMiIsImFsZyI6IlJTMjU2In0...
WIX_SITE_ID=VECO
WIX_ACCOUNT_ID=vetechnologiesco@gmail.com
DOMAIN_NAME=vigliottaproperties.com
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/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
```

#### 1.4 Deploy
- Click **"Create Web Service"**
- Wait 3-5 minutes
- Test your Render URL (e.g., `https://vpco.onrender.com/api/health`)

---

### Step 2: Configure DNS in Wix (5 minutes)

#### 2.1 Get DNS Records from Render
1. In Render dashboard → **Settings** → **Custom Domain**
2. Add both domains:
   - `vigliottaproperties.com`
   - `www.vigliottaproperties.com`
3. Render shows you the DNS records needed (write these down!)

**Example (your actual values will be shown by Render):**
```
CNAME: www → vpco.onrender.com
A: @ → 216.24.57.1
```

#### 2.2 Update Wix DNS
1. Go to https://www.wix.com/my-account/domains
2. Click on **vigliottaproperties.com** → **"Manage DNS Records"**
3. Add these records:

**For www subdomain:**
```
Type: CNAME
Host: www
Value: vpco.onrender.com (use your actual Render URL)
TTL: 1 Hour
```

**For apex domain (vigliottaproperties.com):**
```
Type: A
Host: @ (or leave blank)
Value: [IP address from Render dashboard]
TTL: 1 Hour
```

**Important**: If a CNAME for `www` already exists, DELETE it first!

---

### Step 3: Wait & Verify (15-30 minutes)

#### 3.1 Wait for DNS Propagation
- Minimum: 10-15 minutes
- Typical: 30 minutes
- Maximum: 2 hours

#### 3.2 Check DNS Status
```bash
# Check if DNS has propagated
dig vigliottaproperties.com +short
dig www.vigliottaproperties.com +short

# Or use online tool
# Visit: https://dnschecker.org
# Enter: vigliottaproperties.com
```

#### 3.3 Test Your Live Site
Once DNS propagates, test these URLs:

```bash
# Health check
curl https://vigliottaproperties.com/api/health

# Services
curl https://vigliottaproperties.com/api/services

# Frontend
# Open in browser: https://vigliottaproperties.com
```

#### 3.4 HTTPS/SSL
- Render automatically provisions SSL (Let's Encrypt)
- Happens within 5 minutes after DNS verifies
- Both HTTP and HTTPS will work
- HTTPS will be the default

---

## Success Checklist ✅

- [ ] Render service deployed and running
- [ ] Environment variables set in Render dashboard
- [ ] Custom domains added in Render
- [ ] CNAME record for `www` added in Wix DNS
- [ ] A record for `@` (apex) added in Wix DNS
- [ ] DNS propagated (verified with dig/nslookup)
- [ ] `https://vigliottaproperties.com` loads
- [ ] `https://www.vigliottaproperties.com` loads
- [ ] Contact form submits to Slack
- [ ] All pages working (Home, About, Services, Contact)

---

## Quick Troubleshooting

### "DNS not resolving yet"
→ Wait 30 more minutes, then check again

### "CNAME already exists" error in Wix
→ Delete the existing `www` CNAME (pointing to Wix), then add new one

### "SSL not working"
→ Wait 5 minutes after DNS propagates, Render auto-provisions SSL

### "Site shows 404"
→ Check Render logs (Dashboard → Logs tab) for errors

### "Contact form not working"
→ Check SLACK_WEBHOOK_URL is set in Render environment variables

---

## Need More Details?

See full documentation:
- **DEPLOYMENT.md** - Complete deployment guide
- **DNS_SETUP.md** - Detailed DNS configuration
- **README.md** - Project overview and API docs

---

## Support

- **Render Status**: https://status.render.com
- **Render Docs**: https://render.com/docs
- **Wix DNS Help**: https://support.wix.com/en/article/adding-or-updating-cname-records-in-your-wix-account

---

## Timeline Summary

| Step | Duration | Status |
|------|----------|--------|
| Deploy to Render | 5-10 min | 🔵 Action required |
| Add DNS in Wix | 5 min | 🔵 Action required |
| DNS Propagation | 15-30 min | ⏳ Wait time |
| SSL Provisioning | 5 min | ⚡ Automatic |
| **Total** | **30-50 min** | |

---

🎉 **Your site will be live at https://vigliottaproperties.com!**
