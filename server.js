// require('dotenv').config(); // Removed - environment variables now sourced from Azure App Service
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Environment Configuration (from Azure App Service environment variables)
const {
    WIX_API_KEY,
    WIX_API_TOKEN,
    WIX_SITE_ID,
    WIX_ACCOUNT_ID,
    DOMAIN_NAME,
    SLACK_WEBHOOK_URL
} = process.env;

// Wix API Configuration
const WIX_CONFIG = {
    apiKey: WIX_API_KEY,
    apiToken: WIX_API_TOKEN,
    siteId: WIX_SITE_ID,
    accountId: WIX_ACCOUNT_ID,
    domainName: DOMAIN_NAME
};

// Validate environment configuration
if (WIX_CONFIG.apiKey && WIX_CONFIG.apiToken) {
    console.log('✅ Wix API credentials loaded from Azure App Service');
} else {
    console.warn('⚠️ Wix API credentials not found. Please set WIX_API_KEY and WIX_API_TOKEN in Azure App Service Application Settings');
}

if (SLACK_WEBHOOK_URL) {
    console.log('✅ Slack webhook configured from Azure App Service');
} else {
    console.warn('⚠️ Slack webhook not configured. Set SLACK_WEBHOOK_URL in Azure App Service Application Settings. Contact submissions will only be stored in memory.');
}

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files from root directory
app.use(express.static(path.join(__dirname)));

// Helper function to send Slack notification
async function sendSlackNotification(contact) {
    if (!SLACK_WEBHOOK_URL) {
        return { success: false, message: 'Slack webhook not configured' };
    }

    try {
        const payload = {
            text: '🔔 New Contact Form Submission',
            blocks: [
                {
                    type: 'header',
                    text: {
                        type: 'plain_text',
                        text: '📬 New Contact Form Submission',
                        emoji: true
                    }
                },
                {
                    type: 'section',
                    fields: [
                        {
                            type: 'mrkdwn',
                            text: `*Name:*\n${contact.name}`
                        },
                        {
                            type: 'mrkdwn',
                            text: `*Email:*\n${contact.email}`
                        }
                    ]
                },
                {
                    type: 'section',
                    text: {
                        type: 'mrkdwn',
                        text: `*Message:*\n${contact.message}`
                    }
                },
                {
                    type: 'context',
                    elements: [
                        {
                            type: 'mrkdwn',
                            text: `Submitted: ${new Date(contact.timestamp).toLocaleString()} | ID: ${contact.id}`
                        }
                    ]
                }
            ]
        };

        const response = await fetch(SLACK_WEBHOOK_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(payload)
        });

        if (!response.ok) {
            throw new Error(`Slack API error: ${response.status}`);
        }

        return { success: true, message: 'Slack notification sent' };
    } catch (error) {
        console.error('Error sending Slack notification:', error);
        return { success: false, message: error.message };
    }
}

// In-memory data store (replace with database in production)
let contacts = [];
let services = [
    { 
        id: 1, 
        name: 'Technology Solutions', 
        description: 'Strategic technology consulting and implementation. We help you navigate digital transformation with practical, data-driven roadmaps that balance innovation with reliable execution.',
        category: 'technology'
    },
    { 
        id: 2, 
        name: 'Real Estate Investment', 
        description: 'Thoughtful real estate investment and development. We focus on fundamentals—location, market data, and long-term value—to build sustainable portfolios that compound over time.',
        category: 'real-estate'
    },
    { 
        id: 3, 
        name: 'Strategic Partnership', 
        description: 'Collaborative partnership and advisory services. We listen first, set clear goals, and remove roadblocks so you can focus on what matters most—growing your business and serving your customers.',
        category: 'advisory'
    }
];

// API Routes

// Health check
app.get('/api/health', (req, res) => {
    res.json({ 
        success: true, 
        data: {
            status: 'ok', 
            timestamp: new Date().toISOString() 
        }
    });
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
app.post('/api/contact', async (req, res) => {
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

    // Send Slack notification (non-blocking)
    const slackResult = await sendSlackNotification(contact);
    if (slackResult.success) {
        console.log('✅ Slack notification sent');
    } else {
        console.warn('⚠️ Slack notification failed:', slackResult.message);
    }

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
