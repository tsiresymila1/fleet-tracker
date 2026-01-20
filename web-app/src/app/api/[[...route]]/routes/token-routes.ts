import { Hono } from 'hono';
import { supabaseAdmin } from '@/lib/supabase';

export const createTokenRoutes = () => {
  const tokenRoutes = new Hono();

  // Create API token (requires user session, not API token)
  tokenRoutes.post('/tokens', async (c) => {
    try {
      const body = await c.req.json();
      const { name, scope = 'read' } = body;

      // Get user from session (this would need to be implemented with session auth)
      // For now, we'll use a user_id from the request body in development
      // In production, extract from session cookie/JWT
      const userId = body.user_id;

      if (!userId || !name) {
        return c.json({ error: 'Missing required fields: user_id, name' }, 400);
      }

      if (!['read', 'read-write', 'admin'].includes(scope)) {
        return c.json({ error: 'Invalid scope. Must be: read, read-write, or admin' }, 400);
      }

      // Generate token
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      let tokenValue = '';
      for (let i = 0; i < 32; i++) {
        tokenValue += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      const token = `ft_${tokenValue}`;

      // Insert token
      const { data, error } = await supabaseAdmin
        .from('api_tokens')
        .insert({
          user_id: userId,
          name,
          token,
          scope,
        })
        .select()
        .single();

      if (error) {
        console.error('Error creating token:', error);
        return c.json({ error: 'Failed to create token' }, 500);
      }

      return c.json({ data }, 201);
    } catch (error) {
      console.error('Error:', error);
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  // List user's API tokens
  tokenRoutes.get('/tokens', async (c) => {
    try {
      const userId = c.req.query('user_id');
      
      if (!userId) {
        return c.json({ error: 'Missing user_id parameter' }, 400);
      }

      const { data, error } = await supabaseAdmin
        .from('api_tokens')
        .select('id, name, scope, created_at, last_used_at')
        .eq('user_id', userId)
        .order('created_at', { ascending: false });

      if (error) {
        return c.json({ error: 'Failed to fetch tokens' }, 500);
      }

      return c.json({ data: data || [] });
    } catch {
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  // Delete API token
  tokenRoutes.delete('/tokens/:tokenId', async (c) => {
    try {
      const tokenId = c.req.param('tokenId');
      const userId = c.req.query('user_id');

      if (!userId) {
        return c.json({ error: 'Missing user_id parameter' }, 400);
      }

      const { error } = await supabaseAdmin
        .from('api_tokens')
        .delete()
        .eq('id', tokenId)
        .eq('user_id', userId); // Ensure user owns the token

      if (error) {
        return c.json({ error: 'Failed to delete token' }, 500);
      }

      return c.json({ success: true });
    } catch {
      return c.json({ error: 'Internal server error' }, 500);
    }
  });

  return tokenRoutes;
};
