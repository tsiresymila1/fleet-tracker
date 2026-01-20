import { Context, Hono, Next } from 'hono';
import { supabaseAdmin } from '@/lib/supabase';

type DeviceVariables = {
  deviceId: string;
};

// Device Authentication Middleware
export const deviceAuth = async (c: Context<{ Variables: DeviceVariables }>, next: Next) => {
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (serviceKey) {
    try {
      const payload = JSON.parse(Buffer.from(serviceKey.split('.')[1], 'base64').toString());
      console.log(`DEBUG: Service Key Role: '${payload.role}'`);
      
      if (payload.role === 'anon') {
        console.error("CRITICAL CONFIG ERROR: Your 'SUPABASE_SERVICE_ROLE_KEY' in .env.local has the 'anon' role!");
        console.error("You MUST update it with the 'service_role' (secret) key from your Supabase Dashboard -> Project Settings -> API.");
        return c.json({ error: 'Server Configuration Error: Invalid Service Key' }, 500);
      }
    } catch (e) {
      console.log('DEBUG: Could not decode Service Key JWT');
    }
  }
  
  const deviceKey = c.req.header('X-DEVICE-KEY')?.trim();
  const deviceId = c.req.header('X-DEVICE-ID')?.trim();

  console.log('Device Key:', deviceKey);
  console.log('Device ID:', deviceId);

  if (!deviceKey || !deviceId) {
    return c.json({ error: 'Missing authentication headers' }, 401);
  }

  // DEBUG: Check general visibility
  const { data: allDevices, error: listError } = await supabaseAdmin
    .from('devices')
    .select('device_id')
    .limit(5);
  
  console.log(`DEBUG: Admin Client can see ${allDevices?.length || 0} devices. First few: ${JSON.stringify(allDevices)}`);
  if (listError) console.error("DEBUG: List Error:", listError);

  // Fetch device by ID
  const { data: device, error } = await supabaseAdmin
    .from('devices')
    .select('id, is_enabled, secret_key')
    .eq('device_id', deviceId)
    .maybeSingle();

  if (error) {
    console.error(`DB Error fetching device: ${JSON.stringify(error)}`);
    return c.json({ error: 'Database error' }, 500);
  }

  if (!device) {
    console.error(`Device not found for ID: '${deviceId}'`);
    return c.json({ error: 'Unauthorized: Device not found' }, 401);
  }

  // Secure comparison
  if (device.secret_key.trim() !== deviceKey) {
     console.error(`Key verify failed. Received: '${deviceKey}', Stored: '${device.secret_key}'`);
     return c.json({ error: 'Unauthorized: Invalid Key' }, 401);
  }

  if (!device.is_enabled) {
    return c.json({ error: 'Device disabled' }, 403);
  }

  c.set('deviceId', device.id);
  await next();
};

interface Device {
  id: string;
  is_enabled: boolean;
  device_name: string;
  secret_key: string;
}

function handleExistingDevice(c: Context, device: Device, secretKey: string | null) {
  if (secretKey && device.secret_key !== secretKey) {
    return c.json({ 
      success: false, 
      authorized: false, 
      error: 'Invalid credentials' 
    }, 401);
  }
  
  if (!device.is_enabled) {
    return c.json({ 
      success: true, 
      authorized: false,
      device_name: device.device_name,
      secret_key: device.secret_key
    });
  }

  return c.json({ 
    success: true, 
    authorized: true,
    device_name: device.device_name,
    secret_key: device.secret_key 
  });
}

// Create device routes
export const createDeviceRoutes = () => {
  const deviceRoutes = new Hono<{ Variables: DeviceVariables }>();

  // Device Tracking Endpoint
  deviceRoutes.post('/track', deviceAuth, async (c) => {
    const body = await c.req.json();
    const internalDeviceId = c.get('deviceId');

    const mapPositionData = (pos: Record<string, number | string>) => ({
      device_id: internalDeviceId,
      latitude: pos.latitude,
      longitude: pos.longitude,
      speed: pos.speed,
      heading: pos.heading,
      altitude: pos.altitude,
      status: pos.status,
      recorded_at: pos.recorded_at,
    });

    let dataToInsert = [];

    if (Array.isArray(body)) {
      dataToInsert = body.map(mapPositionData);
    } else if (body.positions && Array.isArray(body.positions)) {
      dataToInsert = body.positions.map(mapPositionData);
    } else {
      dataToInsert = [mapPositionData(body)];
    }
    
    if (dataToInsert.length === 0) {
      return c.json({ success: true, message: 'No data to insert' });
    }

    const { error } = await supabaseAdmin.from('positions').insert(dataToInsert);

    if (error) {
      console.error('Error inserting positions:', error);
      return c.json({ error: 'Failed to record positions' }, 500);
    }

    await supabaseAdmin.from('devices').update({ last_seen_at: new Date().toISOString() }).eq('id', internalDeviceId);

    return c.json({ success: true, count: dataToInsert.length });
  });

  // Device Initialization (Register/Verify)
  deviceRoutes.post('/initialize', async (c) => {
    const { device_id, secret_key } = await c.req.json();

    if (!device_id) {
      return c.json({ error: 'Missing device_id' }, 400);
    }

    const normalizedDeviceId = device_id.toString().trim().toUpperCase();
    const newSecret = crypto.randomUUID();
    const deviceName = `Device ${normalizedDeviceId.substring(0, 6)}`;

    const { data: device, error } = await supabaseAdmin.rpc('register_new_device', {
      p_device_id: normalizedDeviceId,
      p_secret_key: newSecret,
      p_device_name: deviceName
    });

    if (error) {
      console.error('RPC Error:', error);
      return c.json({ 
        success: false, 
        authorized: false, 
        error: `Registration error: ${error.message}` 
      }, 500);
    }

    if (!device) {
      return c.json({ error: 'Device lookup failed' }, 500);
    }

    return handleExistingDevice(c, device, secret_key);
  });

  // Get device info
  deviceRoutes.get('/device', deviceAuth, async (c) => {
    const deviceId = c.get('deviceId');
    
    const { data, error } = await supabaseAdmin
      .from('devices')
      .select('device_id, device_name, is_enabled, last_seen_at')
      .eq('id', deviceId)
      .single();

    if (error) {
      return c.json({ error: 'Failed to fetch device info' }, 500);
    }

    return c.json({ 
      device_id: data.device_id,
      device_name: data.device_name,
      authorized: data.is_enabled
    });
  });

  // Update device info (from mobile)
  deviceRoutes.patch('/device', deviceAuth, async (c) => {
    const deviceId = c.get('deviceId');
    const body = await c.req.json();

    const { data, error } = await supabaseAdmin
      .from('devices')
      .update({
        device_name: body.device_name,
      })
      .eq('id', deviceId)
      .select()
      .single();

    if (error) {
      return c.json({ error: 'Failed to update device' }, 500);
    }

    return c.json({ 
      device_id: data.device_id,
      device_name: data.device_name,
      authorized: data.is_enabled
    });
  });

  return deviceRoutes;
};
