# VPCO Production Startup Script (PowerShell)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "🚀 Starting VPCO in Production Mode" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Note: Environment variables are now sourced from Azure App Service Application Settings
# For local development with Wix/Slack integrations, set environment variables manually:
# $env:WIX_API_KEY = "..."
# $env:SLACK_WEBHOOK_URL = "..."
Write-Host "ℹ️  Environment variables sourced from Azure App Service (or local exports)" -ForegroundColor Yellow
Write-Host ""

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Blue
    npm install
    Write-Host ""
}

# Run tests
Write-Host "🧪 Running tests..." -ForegroundColor Blue
npm test
$testExitCode = $LASTEXITCODE

if ($testExitCode -ne 0) {
    Write-Host ""
    Write-Host "❌ Tests failed! Please fix errors before starting production server." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ All tests passed!" -ForegroundColor Green
Write-Host ""

# Start production server
Write-Host "🌐 Starting production server..." -ForegroundColor Green
Write-Host "   Server: http://localhost:3000" -ForegroundColor White
Write-Host "   API: http://localhost:3000/api" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

$env:NODE_ENV = "production"
npm start