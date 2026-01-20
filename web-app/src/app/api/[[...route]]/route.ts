import { Hono } from 'hono';
import { handle } from 'hono/vercel';
import { createDeviceRoutes } from './routes/device-routes';
import { createTokenRoutes } from './routes/token-routes';
import { createV1Routes } from './routes/v1-routes';
import { createMobileRoutes } from './routes/mobile-routes';

export const dynamic = 'force-dynamic';

const app = new Hono().basePath('/api');

// Health check
app.get('/health', (c) => c.json({ status: 'ok' }));

// Mount routes
app.route('/', createDeviceRoutes());
app.route('/', createTokenRoutes());
app.route('/v1', createV1Routes()); // Mount v1 routes under /api/v1
app.route('/', createMobileRoutes()); // Mount mobile routes (like /positions) under /api

export const GET = handle(app);
export const POST = handle(app);
export const PUT = handle(app);
export const DELETE = handle(app);
export const PATCH = handle(app);