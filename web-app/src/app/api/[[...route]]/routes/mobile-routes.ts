import { Hono } from 'hono';
import { supabaseAdmin } from '@/lib/supabase';
import { deviceAuth } from './device-routes';

type DeviceVariables = {
  deviceId: string;
};

export const createMobileRoutes = () => {
  const mobileRoutes = new Hono<{ Variables: DeviceVariables }>();

  // Use device auth for mobile endpoints
  mobileRoutes.use('*', deviceAuth);

  // Get positions history (for mobile app)
  mobileRoutes.get('/positions', async (c) => {
    try {
      const deviceId = c.get('deviceId');
      const startDate = c.req.query('startDate');
      const endDate = c.req.query('endDate');
      const limit = parseInt(c.req.query('limit') || '1000'); // Higher limit for history

      if (!startDate || !endDate) {
           return c.json({ error: 'Missing startDate or endDate' }, 400);
      }

      console.log(`Fetching history for device ${deviceId} from ${startDate} to ${endDate}`);

      const { data, error } = await supabaseAdmin
        .from('positions')
        .select(`
          id,
          latitude,
          longitude,
          speed,
          heading,
          altitude,
          status,
          recorded_at
        `)
        .eq('device_id', deviceId)
        .gte('recorded_at', startDate)
        .lte('recorded_at', endDate)
        .order('recorded_at', { ascending: true }) // Ascending for trajectory plotting
        .limit(Math.min(limit, 5000)); // Max 5000 points for history

      if (error) {
        console.error('Error fetching position history:', error);
        return c.json({ error: 'Failed to fetch positions' }, 500);
      }

      return c.json({ success: true, positions: data || [] });
    } catch (error) {
      console.error('Internal error in mobile positions:', error);
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  return mobileRoutes;
};
