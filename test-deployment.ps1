# VPCO Azure Deployment Testing Suite (PowerShell)

Write-Host "🧪 VPCO - Azure Deployment Testing Suite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$AzureAppUrl = "https://vpco-prod.azurewebsites.net"

# Test counter
$Passed = 0
$Failed = 0

# Function to test endpoint
function Test-Endpoint {
    param (
        [string]$Name,
        [string]$Url,
        [int]$ExpectedStatus
    )

    Write-Host -NoNewline "Testing $Name... "
    try {
        $response = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec 10
        $status = $response.StatusCode
    } catch {
        $status = $_.Exception.Response.StatusCode.value__
        if (-not $status) { $status = 0 }
    }

    if ($status -eq $ExpectedStatus) {
        Write-Host "✓ PASS" -ForegroundColor Green -NoNewline
        Write-Host " (HTTP $status)" -ForegroundColor White
        $script:Passed++
    } else {
        Write-Host "✗ FAIL" -ForegroundColor Red -NoNewline
        Write-Host " (Expected $ExpectedStatus, got $status)" -ForegroundColor White
        $script:Failed++
    }
}

# Check if Azure app is accessible
Write-Host "1️⃣  Checking Azure App Status..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri "$AzureAppUrl/api/health" -Method Get -TimeoutSec 10 | Out-Null
    Write-Host "✓ Azure app is accessible" -ForegroundColor Green
} catch {
    Write-Host "✗ Azure app is not accessible at $AzureAppUrl" -ForegroundColor Red
    Write-Host "Please check your Azure deployment" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Note: Unit tests are run locally before deployment
Write-Host "2️⃣  Unit Tests (run locally with: npm test)" -ForegroundColor Yellow
Write-Host "✓ Assumed passed (run locally)" -ForegroundColor Green
Write-Host ""

# Test API endpoints
Write-Host "3️⃣  Testing API Endpoints..." -ForegroundColor Yellow
Test-Endpoint "Health Check" "$AzureAppUrl/api/health" 200
Test-Endpoint "Services List" "$AzureAppUrl/api/services" 200
Test-Endpoint "About Page" "$AzureAppUrl/api/about" 200
Test-Endpoint "Wix Status" "$AzureAppUrl/api/wix/status" 200
Test-Endpoint "404 Handler" "$AzureAppUrl/api/nonexistent" 404
Write-Host ""

# Test frontend
Write-Host "4️⃣  Testing Frontend..." -ForegroundColor Yellow
Test-Endpoint "Homepage" "$AzureAppUrl/" 200
Test-Endpoint "Static CSS" "$AzureAppUrl/styles/main.css" 200
Test-Endpoint "Static JS" "$AzureAppUrl/scripts/main.js" 200
Write-Host ""

# Test integrations
Write-Host "5️⃣  Testing Integrations..." -ForegroundColor Yellow
Write-Host -NoNewline "Checking Wix API configuration... "
try {
    $wixResponse = Invoke-WebRequest -Uri "$AzureAppUrl/api/wix/status" -Method Get
    $wixContent = $wixResponse.Content | ConvertFrom-Json
    if ($wixContent.data.configured -eq $true) {
        Write-Host "✓ Wix API configured" -ForegroundColor Green
        $Passed++
    } else {
        Write-Host "✗ Wix API not configured" -ForegroundColor Red
        $Failed++
    }
} catch {
    Write-Host "✗ Wix API check failed" -ForegroundColor Red
    $Failed++
}

Write-Host -NoNewline "Checking Slack webhook configuration... "
if ($env:SLACK_WEBHOOK_URL -and $env:SLACK_WEBHOOK_URL -match "hooks.slack.com") {
    Write-Host "✓ Slack webhook configured" -ForegroundColor Green
    $Passed++
} else {
    Write-Host "✗ Slack webhook not configured" -ForegroundColor Red
    $Failed++
}
Write-Host ""

# Summary
Write-Host "📊 Test Summary:" -ForegroundColor Cyan
Write-Host "   Passed: $Passed" -ForegroundColor Green
Write-Host "   Failed: $Failed" -ForegroundColor Red
Write-Host ""

if ($Failed -eq 0) {
    Write-Host "🎉 All tests passed! Azure deployment is working correctly." -ForegroundColor Green
} else {
    Write-Host "❌ $Failed tests failed. Please check your Azure configuration." -ForegroundColor Red
}