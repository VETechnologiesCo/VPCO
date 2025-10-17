require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Wix API Configuration (from environment variables)
const WIX_CONFIG = {
    apiKey: process.env.WIX_API_KEY,
    apiToken: process.env.WIX_API_TOKEN,
    siteId: process.env.WIX_SITE_ID,
    accountId: process.env.WIX_ACCOUNT_ID,
    domainName: process.env.DOMAIN_NAME
};

// Validate Wix credentials are loaded
if (WIX_CONFIG.apiKey && WIX_CONFIG.apiToken) {
    console.log('✅ Wix API credentials loaded');
} else {
    console.warn('⚠️  Wix API credentials not found. Create .env file from .env.example');
}

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files from root directory
app.use(express.static(path.join(__dirname)));

// In-memory data store (replace with database in production)
let contacts = [];
let services = [
    { id: 1, name: 'Consulting', description: 'Expert guidance for your technology needs.' },
    { id: 2, name: 'Development', description: 'Custom software solutions tailored to you.' },
    { id: 3, name: 'Support', description: 'Ongoing maintenance and technical assistance.' }
];

// API Routes

// Health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Get all services
app.get('/api/services', (req, res) => {
    res.json({ success: true, data: services });
});

// Get single service
app.get('/api/services/:id', (req, res) => {
    const service = services.find(s => s.id === parseInt(req.params.id));
    if (!service) {
        return res.status(404).json({ success: false, error: 'Service not found' });
    }
    res.json({ success: true, data: service });
});

// Submit contact form
app.post('/api/contact', (req, res) => {
    const { name, email, message } = req.body;

    // Validation
    if (!name || !email || !message) {
        return res.status(400).json({ 
            success: false, 
            error: 'All fields (name, email, message) are required' 
        });
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        return res.status(400).json({ 
            success: false, 
            error: 'Invalid email format' 
        });
    }

    // Store contact (in production, send email or save to database)
    const contact = {
        id: contacts.length + 1,
        name,
        email,
        message,
        timestamp: new Date().toISOString()
    };
    contacts.push(contact);

    console.log('New contact submission:', contact);

    res.status(201).json({ 
        success: true, 
        message: 'Contact form submitted successfully',
        data: { id: contact.id }
    });
});

// Get all contacts (admin endpoint - add auth in production)
app.get('/api/contacts', (req, res) => {
    res.json({ success: true, data: contacts });
});

// About/Company info
app.get('/api/about', (req, res) => {
    res.json({
        success: true,
        data: {
            company: 'VPCO',
            fullName: 'VE Technologies Co.',
            tagline: 'Investing in the future through technology and real estate',
            description: 'VPCO invests in the future by defining technology and real estate solutions. We keep things simple: earn trust by doing what we say, win by focusing on fundamentals and ethics, and lead by listening first, setting clear goals, and removing roadblocks so others can shine.',
            mission: 'We are steady under pressure, transparent about tradeoffs, and comfortable owning results—good or bad. Our growth mindset is practical: small, compounding improvements, data over opinions, and roadmaps that balance today\'s execution with tomorrow\'s opportunities.',
            values: [
                'Earn trust through action and integrity',
                'Focus on fundamentals and ethics',
                'Lead by listening and empowering others',
                'Transparent communication and accountability',
                'Data-driven decision making',
                'Respect for people and relationships'
            ],
            commitment: 'When you work with VPCO, you get a reliable partner who cares about outcomes and the people who make them possible. We stay professional—prepared, responsive, and respectful of your time—and we protect relationships by communicating clearly, keeping confidences, and sharing credit.',
            founded: 2025
        }
    });
});

// Wix integration status
app.get('/api/wix/status', (req, res) => {
    const isConfigured = !!(WIX_CONFIG.apiKey && WIX_CONFIG.apiToken);
    
    res.json({
        success: true,
        data: {
            configured: isConfigured,
            hasApiKey: !!WIX_CONFIG.apiKey,
            hasApiToken: !!WIX_CONFIG.apiToken,
            hasSiteId: !!WIX_CONFIG.siteId,
            domain: WIX_CONFIG.domainName || 'not configured'
        }
    });
});

// Example: Wix API proxy endpoint (add your Wix API logic here)
app.get('/api/wix/example', async (req, res) => {
    if (!WIX_CONFIG.apiKey || !WIX_CONFIG.apiToken) {
        return res.status(503).json({
            success: false,
            error: 'Wix API not configured. Please set up .env file.'
        });
    }

    // Example: This is where you'd make calls to Wix APIs
    // const axios = require('axios');
    // const response = await axios.get('https://www.wixapis.com/v1/...", {
    //     headers: {
    //         'Authorization': WIX_CONFIG.apiToken,
    //         'wix-api-key': WIX_CONFIG.apiKey
    //     }
    // });

    res.json({
        success: true,
        message: 'Wix API credentials are configured',
        note: 'Add your Wix API calls here'
    });
});

// 404 handler for API routes
app.use('/api/*', (req, res) => {
    res.status(404).json({ 
        success: false, 
        error: 'API endpoint not found' 
    });
});

// Serve index.html for all other routes (SPA support)
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({ 
        success: false, 
        error: 'Internal server error' 
    });
});

// Start server only when run directly (not when imported by tests)
if (require.main === module) {
    app.listen(PORT, () => {
        console.log(`🚀 VPCO API Server running on http://localhost:${PORT}`);
        console.log(`📡 API endpoints available at http://localhost:${PORT}/api`);
        console.log(`🌐 Frontend available at http://localhost:${PORT}`);
    });
}

module.exports = app;
