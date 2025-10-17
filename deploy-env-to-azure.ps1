# Deploy VPCO Environment Variables to Azure App Service (PowerShell)

Write-Host "🚀 Deploying VPCO Environment Variables to Azure App Service" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Azure CLI is installed
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Azure CLI is not installed." -ForegroundColor Red
    Write-Host "Please install it first:" -ForegroundColor Yellow
    Write-Host "  curl -L https://aka.ms/InstallAzureCli | bash" -ForegroundColor White
    Write-Host "  Or visit: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" -ForegroundColor White
    exit 1
}

# Check if logged in
$account = az account show 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Not logged in to Azure. Please run: az login" -ForegroundColor Red
    exit 1
}

# Configuration
$ResourceGroup = "vpco-prod-rg"
$AppName = "vpco-prod"  # Update this if your app service name is different

Write-Host "Resource Group: $ResourceGroup" -ForegroundColor White
Write-Host "App Service Name: $AppName" -ForegroundColor White
Write-Host ""

# Check if .env exists
if (-not (Test-Path ".env")) {
    Write-Host "❌ Error: .env file not found" -ForegroundColor Red
    exit 1
}

# Load environment variables from .env
Write-Host "📖 Loading environment variables from .env..." -ForegroundColor Blue
$content = Get-Content ".env" -Raw
$envLines = $content -split "`n" | Where-Object { $_ -match '^[^#]' -and $_ -match '=' }

foreach ($line in $envLines) {
    if ($line -match '^([^=]+)=(.*)$') {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        Set-Item -Path "env:$key" -Value $value
    }
}

Write-Host "✅ Environment variables loaded" -ForegroundColor Green
Write-Host ""

# Function to set app setting
function Set-AppSetting {
    param (
        [string]$Key,
        [string]$Value
    )

    if ([string]::IsNullOrEmpty($Value)) {
        Write-Host "⚠️  Skipping empty value for $Key" -ForegroundColor Yellow
        return
    }

    Write-Host -NoNewline "Setting $Key... "
    $result = az webapp config appsettings set --name $AppName --resource-group $ResourceGroup --setting "$Key=$Value" --output none 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Done" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
        $script:Failed++
    }
}

# List of environment variables to deploy
$EnvVars = @(
    "PORT",
    "NODE_ENV",
    "WIX_API_KEY",
    "WIX_API_TOKEN",
    "WIX_SITE_ID",
    "WIX_ACCOUNT_ID",
    "DOMAIN_NAME",
    "SLACK_APP_ID",
    "SLACK_CLIENT_ID",
    "SLACK_CLIENT_SECRET",
    "SLACK_SIGNING_SECRET",
    "SLACK_VERIFICATION_TOKEN",
    "SLACK_WEBHOOK_URL"
)

$Failed = 0
Write-Host "🔧 Setting App Service Application Settings..." -ForegroundColor Blue
Write-Host ""

foreach ($var in $EnvVars) {
    $value = Get-Item -Path "env:$var" -ErrorAction SilentlyContinue
    if ($value) {
        Set-AppSetting -Key $var -Value $value.Value
    } else {
        Write-Host "⚠️  Environment variable $var not found" -ForegroundColor Yellow
    }
}

Write-Host ""
if ($Failed -eq 0) {
    Write-Host "🎉 All environment variables deployed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Restart your App Service: az webapp restart --name $AppName --resource-group $ResourceGroup" -ForegroundColor White
    Write-Host "2. Check your app at: https://$AppName.azurewebsites.net" -ForegroundColor White
} else {
    Write-Host "❌ $Failed settings failed to deploy. Please check the errors above." -ForegroundColor Red
}