const request = require('supertest');
const app = require('../server');

describe('VPCO API and Frontend', () => {
  it('GET /api/health -> 200 with status ok', async () => {
    const res = await request(app).get('/api/health');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('success', true);
    expect(res.body.data).toHaveProperty('status', 'ok');
    expect(res.body.data).toHaveProperty('timestamp');
  });

  it('GET /api/services -> 200 and returns services array', async () => {
    const res = await request(app).get('/api/services');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('success', true);
    expect(Array.isArray(res.body.data)).toBe(true);
    expect(res.body.data.length).toBeGreaterThan(0);
  });

  it('GET /api/services/:id -> 404 for missing service', async () => {
    const res = await request(app).get('/api/services/99999');
    expect(res.statusCode).toBe(404);
    expect(res.body).toHaveProperty('success', false);
  });

  it('POST /api/contact -> 201 on valid submission', async () => {
    const res = await request(app)
      .post('/api/contact')
      .send({ name: 'Tester', email: 'tester@example.com', message: 'Hello' })
      .set('Content-Type', 'application/json');
    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('success', true);
    expect(res.body.data).toHaveProperty('id');
  });

  it('POST /api/contact -> 400 on invalid email', async () => {
    const res = await request(app)
      .post('/api/contact')
      .send({ name: 'Tester', email: 'invalid-email', message: 'Hello' })
      .set('Content-Type', 'application/json');
    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('success', false);
  });

  it('GET /api/about -> 200 with company info', async () => {
    const res = await request(app).get('/api/about');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('success', true);
    expect(res.body.data).toHaveProperty('company', 'VPCO');
  });

  it('GET /api/wix/status -> 200 with configuration flags', async () => {
    const res = await request(app).get('/api/wix/status');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('success', true);
    expect(res.body.data).toHaveProperty('configured');
  });

  it('GET /api/contacts -> 200 with contacts array', async () => {
    const res = await request(app).get('/api/contacts');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('success', true);
    expect(Array.isArray(res.body.data)).toBe(true);
  });

  it('GET / -> 200 serves index.html with title', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.text).toContain('<title>VPCO</title>');
  });

  it('GET /api/unknown -> 404 handler works', async () => {
    const res = await request(app).get('/api/unknown');
    expect(res.statusCode).toBe(404);
    expect(res.body).toHaveProperty('success', false);
  });
});
