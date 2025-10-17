#!/bin/bash
# Test Slack Integration for VPCO Azure Deployment

echo "======================================"
echo "🧪 Testing VPCO Slack Integration"
echo "======================================"
echo ""

# Check if webhook URL is configured in environment
if [ -n "$SLACK_WEBHOOK_URL" ] && [[ $SLACK_WEBHOOK_URL == https://hooks.slack.com* ]]; then
    echo "✅ Slack webhook URL found in environment variables"
else
    echo "⚠️  Warning: SLACK_WEBHOOK_URL not configured or using placeholder"
    echo ""
    echo "For local testing, set the environment variable:"
    echo "  export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/..."
    echo ""
    echo "For Azure deployment, ensure SLACK_WEBHOOK_URL is set in App Service Application Settings"
    echo ""
fi

# Configuration
AZURE_APP_URL="https://vpco-prod.azurewebsites.net"

echo ""
echo "📤 Submitting test contact form to Azure deployment..."
echo ""

# Submit test contact form
RESPONSE=$(curl -s -X POST $AZURE_APP_URL/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@vpco.example.com",
    "message": "This is a test submission from the VPCO Azure deployment integration test."
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
