#!/bin/bash
# Deploy VPCO Environment Variables to Azure App Service

echo "🚀 Deploying VPCO Environment Variables to Azure App Service"
echo "=========================================================="
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed."
    echo "Please install it first:"
    echo "  curl -L https://aka.ms/InstallAzureCli | bash"
    echo "  Or visit: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in
if ! az account show &> /dev/null; then
    echo "❌ Not logged in to Azure. Please run: az login"
    exit 1
fi

# Configuration
RESOURCE_GROUP="vpco-prod-rg"
APP_NAME="vpco-prod"  # Update this if your app service name is different

echo "Resource Group: $RESOURCE_GROUP"
echo "App Service Name: $APP_NAME"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    exit 1
fi

# Load environment variables from .env
echo "📖 Loading environment variables from .env..."
set -a
source .env
set +a

echo "✅ Environment variables loaded"
echo ""

# Function to set app setting
set_app_setting() {
    local key=$1
    local value=$2

    if [ -z "$value" ]; then
        echo "⚠️  Skipping empty value for $key"
        return
    fi

    echo -n "Setting $key... "
    if az webapp config appsettings set \
        --name "$APP_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --setting "$key=$value" \
        --output none; then
        echo "✅ Done"
    else
        echo "❌ Failed"
        return 1
    fi
}

# List of environment variables to deploy
ENV_VARS=(
    "PORT"
    "NODE_ENV"
    "WIX_API_KEY"
    "WIX_API_TOKEN"
    "WIX_SITE_ID"
    "WIX_ACCOUNT_ID"
    "DOMAIN_NAME"
    "SLACK_APP_ID"
    "SLACK_CLIENT_ID"
    "SLACK_CLIENT_SECRET"
    "SLACK_SIGNING_SECRET"
    "SLACK_VERIFICATION_TOKEN"
    "SLACK_WEBHOOK_URL"
)

echo "🔧 Setting App Service Application Settings..."
echo ""

FAILED=0
for var in "${ENV_VARS[@]}"; do
    value=$(eval echo "\$$var")
    if ! set_app_setting "$var" "$value"; then
        ((FAILED++))
    fi
done

echo ""
if [ $FAILED -eq 0 ]; then
    echo "🎉 All environment variables deployed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your App Service: az webapp restart --name $APP_NAME --resource-group $RESOURCE_GROUP"
    echo "2. Check your app at: https://$APP_NAME.azurewebsites.net"
else
    echo "❌ $FAILED settings failed to deploy. Please check the errors above."
fi