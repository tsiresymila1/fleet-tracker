import { Hono } from 'hono';
import { supabaseAdmin } from '@/lib/supabase';
import { apiTokenAuth, requireScope } from '@/middleware/api-token-auth';

type Variables = {
  apiToken: {
    userId: string;
    tokenId: string;
    scope: string;
  };
};

export const createV1Routes = () => {
  const v1Routes = new Hono<{ Variables: Variables }>();

  // Apply auth middleware to all v1 routes
  v1Routes.use('*', apiTokenAuth);

  // Get all devices
  v1Routes.get('/devices', requireScope('read'), async (c) => {
    try {
      const apiToken = c.get('apiToken');
      
      const { data, error } = await supabaseAdmin
        .from('devices')
        .select('id, device_id, device_name, is_enabled, last_seen_at, created_at')
        .eq('user_id', apiToken.userId)
        .order('device_name', { ascending: true });

      if (error) {
        return c.json({ error: 'Failed to fetch devices' }, 500);
      }

      return c.json({ data: data || [] });
    } catch {
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  // Get specific device
  v1Routes.get('/devices/:deviceId', requireScope('read'), async (c) => {
    try {
      const deviceId = c.req.param('deviceId');
      // const apiToken = c.get('apiToken'); // Not used currently, but available

      const { data, error } = await supabaseAdmin
        .from('devices')
        .select('id, device_id, device_name, is_enabled, last_seen_at, created_at')
        .eq('id', deviceId)
        .single();

      if (error || !data) {
        return c.json({ error: 'Device not found' }, 404);
      }

      return c.json({ data });
    } catch {
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  // Get positions (with optional filters)
  v1Routes.get('/positions', requireScope('read'), async (c) => {
    try {
      const deviceId = c.req.query('device_id');
      const startDate = c.req.query('start_date');
      const endDate = c.req.query('end_date');
      const limit = parseInt(c.req.query('limit') || '100');

      let query = supabaseAdmin
        .from('positions')
        .select(`
          id,
          latitude,
          longitude,
          speed,
          heading,
          altitude,
          status,
          recorded_at,
          devices!inner (
            device_id,
            device_name
          )
        `)
        .order('recorded_at', { ascending: false })
        .limit(Math.min(limit, 1000)); // Max 1000 records

      if (deviceId) {
        query = query.eq('device_id', deviceId);
      }

      if (startDate) {
        query = query.gte('recorded_at', startDate);
      }

      if (endDate) {
        query = query.lte('recorded_at', endDate);
      }

      const { data, error } = await query;

      if (error) {
        return c.json({ error: 'Failed to fetch positions' }, 500);
      }

      return c.json({ data: data || [] });
    } catch {
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  // Get latest position for each device
  v1Routes.get('/positions/latest', requireScope('read'), async (c) => {
    try {
      // Get all enabled devices
      const { data: devices, error: devicesError } = await supabaseAdmin
        .from('devices')
        .select('id, device_id, device_name')
        .eq('is_enabled', true);

      if (devicesError) {
        return c.json({ error: 'Failed to fetch devices' }, 500);
      }

      // Get latest position for each device
      const latestPositions = await Promise.all(
        (devices || []).map(async (device) => {
          const { data } = await supabaseAdmin
            .from('positions')
            .select('latitude, longitude, speed, heading, altitude, status, recorded_at')
            .eq('device_id', device.id)
            .order('recorded_at', { ascending: false })
            .limit(1)
            .single();

          return {
            device_id: device.device_id,
            device_name: device.device_name,
            position: data || null,
          };
        })
      );

      return c.json({ data: latestPositions });
    } catch {
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  // Update device (requires read-write scope)
  v1Routes.patch('/devices/:deviceId', requireScope('read-write'), async (c) => {
    try {
      const deviceId = c.req.param('deviceId');
      const body = await c.req.json();

      // Verify device exists
      const { data: device, error: checkError } = await supabaseAdmin
        .from('devices')
        .select('id')
        .eq('id', deviceId)
        .single();

      if (checkError || !device) {
        return c.json({ error: 'Device not found' }, 404);
      }

      // Update device
      const { data, error } = await supabaseAdmin
        .from('devices')
        .update({
          device_name: body.device_name,
          is_enabled: body.is_enabled,
        })
        .eq('id', deviceId)
        .select()
        .single();

      if (error) {
        return c.json({ error: 'Failed to update device' }, 500);
      }

      return c.json({ data });
    } catch {
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  return v1Routes;
};
