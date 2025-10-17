# Test Slack Integration for VPCO Azure Deployment (PowerShell)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "🧪 Testing VPCO Slack Integration" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$AzureAppUrl = "https://vpco-prod.azurewebsites.net"

# Check if webhook URL is configured in environment
if ($env:SLACK_WEBHOOK_URL -and $env:SLACK_WEBHOOK_URL -match "hooks.slack.com") {
    Write-Host "✅ Slack webhook URL found in environment variables" -ForegroundColor Green
} else {
    Write-Host "⚠️  Warning: SLACK_WEBHOOK_URL not configured or using placeholder" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "For local testing, set the environment variable:" -ForegroundColor White
    Write-Host "  `$env:SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/...'" -ForegroundColor White
    Write-Host ""
    Write-Host "For Azure deployment, ensure SLACK_WEBHOOK_URL is set in App Service Application Settings" -ForegroundColor White
    Write-Host ""
}

Write-Host ""
Write-Host "📤 Submitting test contact form to Azure deployment..." -ForegroundColor Blue
Write-Host ""

# Prepare JSON payload
$jsonPayload = @{
    name = "Test User"
    email = "test@vpco.example.com"
    message = "This is a test submission from the VPCO Azure deployment integration test."
} | ConvertTo-Json

# Submit test contact form
try {
    $response = Invoke-WebRequest -Uri "$AzureAppUrl/api/contact" -Method Post -Body $jsonPayload -ContentType "application/json" -TimeoutSec 30
    $responseData = $response.Content | ConvertFrom-Json

    # Check response
    if ($responseData.success -eq $true) {
        Write-Host "✅ Contact form submission successful!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Response:" -ForegroundColor White
        $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
    } else {
        Write-Host "❌ Contact form submission failed!" -ForegroundColor Red
        Write-Host "Response: $($response.Content)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error submitting contact form: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Check your Slack channel for the test notification" -ForegroundColor White
Write-Host "2. Verify the contact form data was processed correctly" -ForegroundColor White
Write-Host "3. If no Slack notification received, check webhook URL configuration" -ForegroundColor White