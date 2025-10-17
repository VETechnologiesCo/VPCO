// VPCO - Main JavaScript

// API Configuration
const API_BASE_URL = window.location.origin + '/api';

// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// CTA Button interaction
const ctaButton = document.querySelector('.cta-button');
if (ctaButton) {
    ctaButton.addEventListener('click', () => {
        const contactSection = document.querySelector('#contact');
        if (contactSection) {
            contactSection.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
}

// Load services from API
async function loadServices() {
    try {
        const response = await fetch(`${API_BASE_URL}/services`);
        const result = await response.json();
        
        if (result.success && result.data) {
            const servicesGrid = document.querySelector('.services-grid');
            
            // Category icons/badges
            const categoryBadges = {
                'technology': '💻',
                'real-estate': '🏢',
                'advisory': '🤝'
            };
            
            servicesGrid.innerHTML = result.data.map(service => `
                <div class="service-card" data-service-id="${service.id}" data-category="${service.category || ''}">
                    <div class="service-category">${categoryBadges[service.category] || '⭐'}</div>
                    <h3>${service.name}</h3>
                    <p>${service.description}</p>
                </div>
            `).join('');
        }
    } catch (error) {
        console.error('Error loading services:', error);
    }
}

// Contact form submission with API
const contactForm = document.querySelector('.contact-form');
if (contactForm) {
    contactForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // Get form values
        const name = contactForm.querySelector('input[type="text"]').value;
        const email = contactForm.querySelector('input[type="email"]').value;
        const message = contactForm.querySelector('textarea').value;
        
        // Disable submit button
        const submitButton = contactForm.querySelector('button[type="submit"]');
        const originalText = submitButton.textContent;
        submitButton.disabled = true;
        submitButton.textContent = 'Sending...';
        
        try {
            const response = await fetch(`${API_BASE_URL}/contact`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ name, email, message })
            });
            
            const result = await response.json();
            
            if (result.success) {
                alert('Thank you for your message! We will get back to you soon.');
                contactForm.reset();
            } else {
                alert(`Error: ${result.error || 'Failed to send message'}`);
            }
        } catch (error) {
            console.error('Error submitting form:', error);
            alert('Failed to send message. Please try again later.');
        } finally {
            submitButton.disabled = false;
            submitButton.textContent = originalText;
        }
    });
}

// Add active state to navigation on scroll
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.nav-links a');

function updateActiveNav() {
    const scrollPosition = window.scrollY + 100;

    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.offsetHeight;
        const sectionId = section.getAttribute('id');

        if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === `#${sectionId}`) {
                    link.classList.add('active');
                }
            });
        }
    });
}

window.addEventListener('scroll', updateActiveNav);
window.addEventListener('load', () => {
    updateActiveNav();
    loadServices();
});

// Console welcome message
console.log('%cVPCO', 'font-size: 24px; font-weight: bold; color: #2563eb;');
console.log('Welcome to VPCO - VE Technologies Co.');
console.log('API Base URL:', API_BASE_URL);
