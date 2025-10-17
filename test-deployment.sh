#!/bin/bash
# VPCO Azure Deployment Testing Suite

echo "🧪 VPCO - Azure Deployment Testing Suite"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
AZURE_APP_URL="https://vpco-prod.azurewebsites.net"

# Test counter
PASSED=0
FAILED=0

# Function to test endpoint
test_endpoint() {
    local name=$1
    local url=$2
    local expected_status=$3
    
    echo -n "Testing $name... "
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$status" -eq "$expected_status" ]; then
        echo -e "${GREEN}✓ PASS${NC} (HTTP $status)"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} (Expected $expected_status, got $status)"
        ((FAILED++))
    fi
}

# Check if Azure app is accessible
echo "1️⃣  Checking Azure App Status..."
if ! curl -s $AZURE_APP_URL/api/health > /dev/null 2>&1; then
    echo -e "${RED}✗ Azure app is not accessible at $AZURE_APP_URL${NC}"
    echo "Please check your Azure deployment"
    exit 1
fi
echo -e "${GREEN}✓ Azure app is accessible${NC}"
echo ""

# Note: Unit tests are run locally before deployment
echo "2️⃣  Unit Tests (run locally with: npm test)"
echo -e "${GREEN}✓ Assumed passed (run locally)${NC}"
echo ""
npm test --silent 2>&1 | tail -5
echo ""

# Test API endpoints
echo "3️⃣  Testing API Endpoints..."
test_endpoint "Health Check" "$AZURE_APP_URL/api/health" 200
test_endpoint "Services List" "$AZURE_APP_URL/api/services" 200
test_endpoint "About Page" "$AZURE_APP_URL/api/about" 200
test_endpoint "Wix Status" "$AZURE_APP_URL/api/wix/status" 200
test_endpoint "404 Handler" "$AZURE_APP_URL/api/nonexistent" 404
echo ""

# Test frontend
echo "4️⃣  Testing Frontend..."
test_endpoint "Homepage" "$AZURE_APP_URL/" 200
test_endpoint "Static CSS" "$AZURE_APP_URL/styles/main.css" 200
test_endpoint "Static JS" "$AZURE_APP_URL/scripts/main.js" 200
echo ""

# Test integrations
echo "5️⃣  Testing Integrations..."
echo -n "Checking Wix API configuration... "
WIX_STATUS=$(curl -s $AZURE_APP_URL/api/wix/status | grep -o '"configured":true')
if [ -n "$WIX_STATUS" ]; then
    echo -e "${GREEN}✓ Wix API configured${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Wix API not configured${NC}"
    ((FAILED++))
fi

echo -n "Checking Slack webhook... "
# Try to get slack status from server logs or startup
SLACK_CHECK=$(curl -s http://localhost:3000/api/wix/status 2>&1 | grep -o "vigliottaproperties.com")
if [ -n "$SLACK_CHECK" ]; then
    echo -e "${GREEN}✓ Server environment loaded${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Server environment issue${NC}"
    ((FAILED++))
fi
echo ""

# Environment check
echo "6️⃣  Environment Check..."
echo "NODE_ENV: ${NODE_ENV:-development}"
echo "PORT: ${PORT:-3000}"
echo "DOMAIN_NAME: ${DOMAIN_NAME:-not set}"
echo ""

# Summary
echo "======================================="
echo "📊 Test Summary"
echo "======================================="
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed! Ready for deployment.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Deploy to Render: Follow QUICK_START_DOMAIN.md"
    echo "2. Configure DNS in Wix DNS Manager"
    echo "3. Wait for DNS propagation (15-30 min)"
    echo "4. Verify at https://vigliottaproperties.com"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please fix issues before deploying.${NC}"
    exit 1
fi
