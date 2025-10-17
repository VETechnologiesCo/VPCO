#!/bin/bash
# Test Slack Integration for VPCO Contact Form

echo "======================================"
echo "🧪 Testing VPCO Slack Integration"
echo "======================================"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo "Please create .env file from .env.example"
    exit 1
fi

# Check if webhook URL is configured
if grep -q "^SLACK_WEBHOOK_URL=https://hooks.slack.com" .env; then
    echo "✅ Slack webhook URL found in .env"
else
    echo "⚠️  Warning: SLACK_WEBHOOK_URL not configured or using placeholder"
    echo ""
    echo "To complete setup:"
    echo "1. Visit: https://api.slack.com/apps/A09M2LDH6KC/incoming-webhooks"
    echo "2. Turn ON 'Activate Incoming Webhooks'"
    echo "3. Click 'Add New Webhook to Workspace'"
    echo "4. Select your channel"
    echo "5. Copy the webhook URL and add to .env:"
    echo "   SLACK_WEBHOOK_URL=https://hooks.slack.com/services/..."
    echo ""
fi

echo ""
echo "📤 Submitting test contact form..."
echo ""

# Submit test contact form
RESPONSE=$(curl -s -X POST http://localhost:3000/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@vpco.example.com",
    "message": "This is a test submission from the VPCO contact form integration test."
  }')

# Check response
if echo "$RESPONSE" | jq -e '.success' > /dev/null 2>&1; then
    echo "✅ Contact form submission successful!"
    echo ""
    echo "Response:"
    echo "$RESPONSE" | jq '.'
    echo ""
    echo "📱 Check your Slack channel for the notification!"
    echo ""
    echo "If you don't see a message in Slack:"
    echo "- Make sure SLACK_WEBHOOK_URL is set in .env"
    echo "- Check server logs for error messages"
    echo "- Verify the webhook URL is correct"
else
    echo "❌ Contact form submission failed"
    echo ""
    echo "Response:"
    echo "$RESPONSE" | jq '.'
fi

echo ""
echo "======================================"
echo "View all submissions at:"
echo "curl http://localhost:3000/api/contacts"
echo "======================================"
