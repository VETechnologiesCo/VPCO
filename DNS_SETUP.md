# DNS Setup Guide for vigliottaproperties.com

## Current Setup

Your domain `vigliottaproperties.com` is managed by Wix with these nameservers:
- ns6.wixdns.net
- ns7.wixdns.net

**Important**: Since Wix controls the nameservers, you cannot change NS records. All DNS changes must be made through Wix DNS Manager.

---

## Option 1: Point to Render (Recommended for Full Control)

If you deploy to Render and want your custom domain to serve your Node.js app:

### Step 1: Deploy to Render
1. Push your code to GitHub
2. Create a Render web service (see main README)
3. Deploy and note your Render URL (e.g., `vpco.onrender.com`)

### Step 2: Add Custom Domain in Render
1. In Render dashboard → Settings → Custom Domains
2. Add: `vigliottaproperties.com` and `www.vigliottaproperties.com`
3. Render will show you the **exact DNS records** to add

### Step 3: Update DNS in Wix
1. Go to Wix Dashboard → Domains → Manage DNS (Advanced Settings)
2. Add the records Render provides (example format):

**For www subdomain:**
```
Type: CNAME
Host: www
Value: vpco.onrender.com (or whatever Render provides)
TTL: 1 Hour or Auto
```

**For apex/root domain (vigliottaproperties.com):**
Render typically provides one of these:
```
Type: A
Host: @ (or leave blank)
Value: 216.24.57.1 (example IP - use Render's actual IP)
TTL: 1 Hour or Auto
```

OR if Render supports ALIAS/ANAME (check their docs):
```
Type: ALIAS or ANAME
Host: @
Value: vpco.onrender.com
```

**Note**: Wix DNS may not support ALIAS records. If Render requires ALIAS and Wix doesn't support it, you'll need to use the A record IP they provide.

### Step 4: Wait for Propagation
- DNS changes take 5-60 minutes
- Check with: `dig vigliottaproperties.com` or `nslookup vigliottaproperties.com`

### Step 5: Verify
- Visit `https://vigliottaproperties.com/api/health`
- Should return `{"status":"ok",...}`

---

## Option 2: Use Wix as Reverse Proxy (Limited)

If you want to keep your site on Wix but integrate your API:

### Not Recommended Because:
- Wix sites have limited custom code capabilities
- You'd lose control over the frontend
- API integration would be complex

### If you must:
1. Deploy your API to a subdomain via CNAME:
   ```
   Type: CNAME
   Host: api
   Value: vpco.onrender.com
   TTL: 1 Hour
   ```
2. Access API at `https://api.vigliottaproperties.com/api/health`
3. Keep Wix for the main site frontend

---

## Option 3: Change Nameservers (Advanced - Loses Wix DNS)

**WARNING**: This removes Wix's DNS control entirely. Only do this if:
- You're NOT using Wix for hosting
- You want full DNS control via Cloudflare/Route53/etc.

### Steps:
1. Register with a DNS provider (Cloudflare recommended - free)
2. Get their nameservers (e.g., `ns1.cloudflare.com`, `ns2.cloudflare.com`)
3. In Wix → Domains → Change Nameservers
4. Update to the new nameservers
5. Configure DNS in your new provider

**You will lose**:
- Wix email (if configured)
- Wix site hosting (if using it)
- Any other Wix DNS records

---

## Recommended Approach for Your Project

Based on your setup:

1. **Deploy to Render** (or Railway/Fly.io)
2. **Add DNS records in Wix** (CNAME for www, A for apex)
3. **Keep Wix nameservers** (no NS changes needed)

### Quick Checklist:
- [ ] Deploy app to Render
- [ ] Get DNS records from Render dashboard
- [ ] Add CNAME for `www` in Wix DNS
- [ ] Add A record for `@` (apex) in Wix DNS
- [ ] Wait 30 minutes
- [ ] Test: `curl https://vigliottaproperties.com/api/health`

---

## Common Issues

**"CNAME already exists"**
- Wix may have default records for `www` pointing to their servers
- Delete the existing CNAME before adding the new one

**"Cannot add A record for apex"**
- Some Wix plans restrict apex domain changes
- Use `www.vigliottaproperties.com` as your primary domain
- Redirect apex to www in Render

**"DNS not propagating"**
- Check with: `nslookup vigliottaproperties.com 8.8.8.8`
- If still showing old values after 2 hours, contact Wix support
- Try clearing browser cache: Ctrl+Shift+R

---

## Need Help?

1. Deploy to Render first
2. Screenshot the DNS records Render asks for
3. Share them and I'll give you the exact Wix DNS config

**No SRV records needed** for this use case - those are for services like email/XMPP, not web hosting.
