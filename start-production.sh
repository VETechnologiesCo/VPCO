#!/bin/bash
# VPCO Production Startup Script

echo "======================================"
echo "🚀 Starting VPCO in Production Mode"
echo "======================================"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo "Please create .env from .env.example"
    exit 1
fi

# Check if node_modules exists
if [ ! -d node_modules ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo ""
fi

# Run tests first
echo "🧪 Running tests..."
npm test
TEST_EXIT_CODE=$?

if [ $TEST_EXIT_CODE -ne 0 ]; then
    echo ""
    echo "❌ Tests failed! Please fix errors before starting production server."
    exit 1
fi

echo ""
echo "✅ All tests passed!"
echo ""

# Start production server
echo "🌐 Starting production server..."
echo "   Server: http://localhost:3000"
echo "   API: http://localhost:3000/api"
echo ""
echo "Press Ctrl+C to stop"
echo ""

NODE_ENV=production npm start
