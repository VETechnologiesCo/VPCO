# Slack Integration Setup for VPCO

This guide will help you set up Slack notifications for contact form submissions.

## What You'll Get

When someone submits the contact form on your website, you'll receive a formatted Slack message in your chosen channel with:
- 📬 Contact name and email
- 💬 Their message
- 🕐 Timestamp and submission ID
- All stored in-memory on the server as backup

## Setup Steps

### 1. Your Slack App (Already Created!)

✅ Your Slack app is already created with these details:
- **App Name**: VPCO Contact Forms
- **App ID**: A09M2LDH6KC
- **Client ID**: 9713201376005.9716693584658
- **Created**: October 17, 2025

Your app credentials are already saved in `.env` file.

### 2. Enable Incoming Webhooks

1. Visit your app: https://api.slack.com/apps/A09M2LDH6KC/incoming-webhooks
2. Toggle **"Activate Incoming Webhooks"** to ON
3. Click **"Add New Webhook to Workspace"**
4. Select the channel where you want notifications (e.g., #vpco-contact-forms, #sales, #general)
5. Click **"Allow"**

### 3. Copy Your Webhook URL

You'll see a webhook URL that looks like:
```
https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXX
```

**Important**: Keep this URL secret! It's like a password for posting to your Slack channel.

### 4. Add to Environment Variables

1. Copy `.env.example` to `.env` if you haven't already:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your webhook URL:
   ```bash
   SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
   ```

3. Save the file

### 5. Restart Your Server

```bash
npm run dev
```

You should see:
```
✅ Slack webhook configured
```

## Testing

Test the integration with curl:

```bash
curl -X POST http://localhost:3000/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "message": "Testing Slack integration!"
  }'
```

Check your Slack channel - you should receive a formatted notification!

## Message Format

The Slack message includes:
- **Header**: "📬 New Contact Form Submission"
- **Name**: Contact's full name
- **Email**: Contact's email address
- **Message**: Their full message
- **Footer**: Timestamp and submission ID

## Customization

You can customize the Slack message format in `server.js` by editing the `sendSlackNotification()` function (around line 42).

### Change the Channel

To send to a different channel:
1. Go back to your Slack app settings
2. Add another webhook for a different channel
3. Update `SLACK_WEBHOOK_URL` in your `.env` file

### Add More Fields

You can add additional fields to the Slack message by modifying the `blocks` array in the payload.

## Troubleshooting

### "Slack webhook not configured" warning
- Check that `SLACK_WEBHOOK_URL` is set in your `.env` file
- Make sure `.env` is in the same directory as `server.js`
- Restart your server after adding the webhook URL

### Slack notification failed
- Verify your webhook URL is correct
- Check that the webhook hasn't been revoked in Slack
- Look at server logs for specific error messages

### Messages not appearing in Slack
- Confirm you're looking at the correct channel
- Check that the Slack app hasn't been removed from the channel
- Test the webhook directly with curl:
  ```bash
  curl -X POST YOUR_WEBHOOK_URL \
    -H "Content-Type: application/json" \
    -d '{"text":"Test message"}'
  ```

## Production Deployment

When deploying to Render (or other platforms):

1. Add `SLACK_WEBHOOK_URL` to your environment variables in the hosting dashboard
2. Never commit your `.env` file to git (it's already in `.gitignore`)
3. The webhook will work from any domain - no CORS issues

## Security Notes

- ✅ Webhook URL is kept in `.env` (never committed to git)
- ✅ Form validation prevents spam/malicious data
- ✅ Email format is validated before sending to Slack
- ✅ Webhook failures don't break the contact form (graceful degradation)

## Additional Features (Optional)

You can enhance the integration:
- Add reaction buttons to mark as "read" or "responded"
- Include a link to reply directly to the contact
- Set up Slack workflows to assign follow-up tasks
- Create separate webhooks for different form types

## Support

For more info on Slack webhooks:
- Slack Webhook Documentation: https://api.slack.com/messaging/webhooks
- Slack Block Kit Builder: https://app.slack.com/block-kit-builder (to customize messages)

---

**Ready to go!** Your contact form submissions will now appear instantly in Slack. 🎉
