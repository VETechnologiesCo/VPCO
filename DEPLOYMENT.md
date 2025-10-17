# 🚀 Deployment Checklist for vigliottaproperties.com

**Status**: Code pushed to GitHub ✅  
**Tests**: All passing (9/9) ✅  
**Branch**: mainVPCO ✅  

---

## Step 1: Create Render Account & Service

### 1.1 Sign up for Render
- Go to https://render.com
- Click "Get Started" → Sign up with GitHub
- Authorize Render to access your GitHub repos

### 1.2 Create New Web Service
1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub account if not already connected
3. Find and select: **`VETechnologiesCo/VPCO`**
4. Click **"Connect"**

### 1.3 Configure the Service
Use these exact settings:

| Setting | Value |
|---------|-------|
| **Name** | `vpco` (or `vigliottaproperties`) |
| **Region** | Choose closest to your users |
| **Branch** | `mainVPCO` |
| **Runtime** | `Node` |
| **Build Command** | `npm install` |
| **Start Command** | `npm start` |
| **Plan** | Starter ($7/month) or Free |

### 1.4 Add Environment Variables
Click **"Advanced"** → **"Add Environment Variable"** and add these:

```env
PORT=3000
NODE_ENV=production
WIX_API_KEY=your_wix_api_key_here
WIX_API_TOKEN=your_wix_api_token_here
WIX_SITE_ID=your_wix_site_id_here
WIX_ACCOUNT_ID=your_wix_account_id_here
DOMAIN_NAME=vigliottaproperties.com
```

### 1.5 Deploy
- Click **"Create Web Service"**
- Render will automatically build and deploy your app
- Wait 2-5 minutes for first deploy
- You'll see a URL like: `https://vpco.onrender.com`

### ✅ Checkpoint 1: Test the Render URL
```bash
curl https://vpco.onrender.com/api/health
# Should return: {"status":"ok","timestamp":"..."}
```

---

## Step 2: Add Custom Domain in Render

### 2.1 Navigate to Custom Domains
- In your Render service dashboard
- Click **"Settings"** (left sidebar)
- Scroll to **"Custom Domain"** section

### 2.2 Add Your Domains
Add BOTH of these domains:
1. `vigliottaproperties.com` (apex/root)
2. `www.vigliottaproperties.com` (www subdomain)

Click **"Add"** for each one.

### 2.3 Copy DNS Instructions
Render will show you **exact DNS records** to add. They'll look like:

**For www.vigliottaproperties.com:**
```
Type: CNAME
Name: www
Value: vpco.onrender.com (your actual Render URL)
```

**For vigliottaproperties.com (apex):**
```
Type: A
Name: @ (or blank)
Value: 216.24.57.1 (example - Render will give you the real IP)
```

**📝 WRITE THESE DOWN** - you'll need them for Step 3!

---

## Step 3: Configure DNS in Wix

### 3.1 Access Wix DNS Manager
1. Go to https://www.wix.com/my-account/domains
2. Find **vigliottaproperties.com**
3. Click **"Manage"** or three dots → **"Manage DNS Records"**
4. Click **"Advanced"** or **"DNS Settings"**

### 3.2 Add CNAME for www
1. Click **"Add Record"** or **"+ Add Record"**
2. Select **"CNAME"**
3. Fill in:
   - **Host/Name**: `www`
   - **Points to/Value**: `vpco.onrender.com` (from Render dashboard)
   - **TTL**: `1 Hour` or `3600` (default is fine)
4. Click **"Save"**

**Note**: If a CNAME for `www` already exists (pointing to Wix), DELETE it first, then add the new one.

### 3.3 Add A Record for Apex
1. Click **"Add Record"**
2. Select **"A"**
3. Fill in:
   - **Host/Name**: `@` (or leave blank for root domain)
   - **Points to/Value**: The IP address from Render (e.g., `216.24.57.1`)
   - **TTL**: `1 Hour` or `3600`
4. Click **"Save"**

### 3.4 Verify DNS Changes
After saving, you should see:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| CNAME | www | vpco.onrender.com | 1 Hour |
| A | @ | 216.24.57.1 (example) | 1 Hour |
| NS | @ | ns6.wixdns.net | 1 Day |
| NS | @ | ns7.wixdns.net | 1 Day |

**DO NOT touch the NS records** - leave them as-is.

---

## Step 4: Wait for DNS Propagation

### 4.1 Expected Wait Time
- **Minimum**: 5-15 minutes
- **Typical**: 30-60 minutes
- **Maximum**: 2-4 hours (rare)

### 4.2 Check Propagation Status
Use these tools:

**Command Line:**
```bash
# Check A record
dig vigliottaproperties.com +short

# Check CNAME
dig www.vigliottaproperties.com +short

# Or use nslookup
nslookup vigliottaproperties.com
nslookup www.vigliottaproperties.com
```

**Online Tools:**
- https://dnschecker.org (check globally)
- https://whatsmydns.net (multiple locations)

### 4.3 What You Should See
```bash
$ dig vigliottaproperties.com +short
216.24.57.1  # Render's IP

$ dig www.vigliottaproperties.com +short
vpco.onrender.com.
216.24.57.1  # Resolves to same IP
```

---

## Step 5: Enable HTTPS in Render

### 5.1 Automatic SSL
- Once DNS is verified, Render automatically provisions SSL (Let's Encrypt)
- This takes 1-5 minutes after DNS propagates
- You'll see **"SSL Verified"** in Render dashboard

### 5.2 Verify HTTPS
```bash
curl https://vigliottaproperties.com/api/health
curl https://www.vigliottaproperties.com/api/health
```

Both should return:
```json
{"status":"ok","timestamp":"2025-10-17T..."}
```

---

## Step 6: Final Verification

### 6.1 Test All Endpoints
```bash
# Health
curl https://vigliottaproperties.com/api/health

# Services
curl https://vigliottaproperties.com/api/services

# About
curl https://vigliottaproperties.com/api/about

# Wix status
curl https://vigliottaproperties.com/api/wix/status
```

### 6.2 Test Frontend
Open in browser:
- https://vigliottaproperties.com
- https://www.vigliottaproperties.com

You should see the VPCO website with:
- Navigation working
- Smooth scrolling
- Contact form functional
- Services displaying

### 6.3 Test Contact Form
1. Open https://vigliottaproperties.com
2. Scroll to Contact section
3. Fill out the form
4. Submit
5. Should see success message

---

## Troubleshooting

### Issue: "DNS not resolving"
**Solution:**
- Wait longer (up to 2 hours)
- Clear browser cache: Ctrl+Shift+Delete
- Try incognito/private mode
- Flush DNS: `ipconfig /flushdns` (Windows) or `sudo dscacheutil -flushcache` (Mac)

### Issue: "CNAME already exists" in Wix
**Solution:**
- Delete existing CNAME for `www` (pointing to Wix)
- Then add the new one pointing to Render

### Issue: "SSL not working"
**Solution:**
- Wait 5 minutes after DNS propagates
- Check Render dashboard → Settings → SSL status
- Force renew: Render → Settings → Custom Domain → click refresh icon

### Issue: "API returns 404"
**Solution:**
- Check Render logs: Dashboard → Logs tab
- Verify environment variables are set
- Restart service: Settings → Manual Deploy → Deploy Latest Commit

### Issue: "Wix won't let me add A record"
**Solution:**
- Some Wix plans restrict apex changes
- Use `www` as primary: redirect apex to www in Render
- Or upgrade Wix plan

---

## Post-Deployment Checklist

- [ ] Render service is deployed and running
- [ ] Environment variables are set in Render
- [ ] Custom domains added in Render
- [ ] DNS CNAME for www added in Wix
- [ ] DNS A record for apex added in Wix
- [ ] DNS propagated (checked with dig/nslookup)
- [ ] HTTPS/SSL working on both domains
- [ ] API endpoints responding correctly
- [ ] Frontend loads and looks correct
- [ ] Contact form submits successfully
- [ ] Wix API credentials working (check /api/wix/status)

---

## Monitoring & Maintenance

### Check Deployment Status
- Render Dashboard: https://dashboard.render.com
- View logs in real-time
- Set up email alerts for downtime

### Update the Site
```bash
# Make changes locally
git add .
git commit -m "feat: your changes"
git push origin mainVPCO

# Render auto-deploys from mainVPCO branch
# Watch progress in Render dashboard
```

### View Logs
```bash
# In Render dashboard → Logs tab
# Or install Render CLI:
npm install -g render-cli
render logs vpco
```

---

## Success! 🎉

Your site should now be live at:
- **Production**: https://vigliottaproperties.com
- **WWW**: https://www.vigliottaproperties.com
- **Render URL**: https://vpco.onrender.com

**Next steps:**
- Share the URL with stakeholders
- Monitor traffic and errors in Render
- Add analytics (Google Analytics, Plausible, etc.)
- Consider adding a database for contact form submissions
- Set up monitoring (UptimeRobot, Pingdom)

---

**Need help?** Check:
- Render Status: https://status.render.com
- Render Docs: https://render.com/docs
- This project's README.md and DNS_SETUP.md
