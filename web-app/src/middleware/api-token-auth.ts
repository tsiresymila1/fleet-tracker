import { Context, Next } from 'hono';
import { supabaseAdmin } from '@/lib/supabase';

interface ApiTokenContext {
  userId: string;
  tokenId: string;
  scope: string;
}

export const apiTokenAuth = async (c: Context<{ Variables: { apiToken: ApiTokenContext } }>, next: Next) => {
  const authHeader = c.req.header('Authorization');
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return c.json({ error: 'Missing or invalid Authorization header' }, 401);
  }

  const token = authHeader.replace('Bearer ', '').trim();

  // Fetch token from database
  const { data: apiToken, error } = await supabaseAdmin
    .from('api_tokens')
    .select('id, user_id, scope')
    .eq('token', token)
    .single();

  if (error || !apiToken) {
    return c.json({ error: 'Invalid API token' }, 401);
  }

  // Update last_used_at (async, don't wait for it)
  supabaseAdmin
    .from('api_tokens')
    .update({ last_used_at: new Date().toISOString() })
    .eq('id', apiToken.id)
    .then(() => {}); // Fire and forget

  // Set token context
  c.set('apiToken', {
    userId: apiToken.user_id,
    tokenId: apiToken.id,
    scope: apiToken.scope,
  });

  await next();
};

// Middleware to check scope
export const requireScope = (requiredScope: 'read' | 'read-write' | 'admin') => {
  const scopeHierarchy = { read: 1, 'read-write': 2, admin: 3 };
  
  return async (c: Context<{ Variables: { apiToken: ApiTokenContext } }>, next: Next) => {
    const apiToken = c.get('apiToken');
    
    if (!apiToken) {
      return c.json({ error: 'Authentication required' }, 401);
    }

    const tokenScopeLevel = scopeHierarchy[apiToken.scope as keyof typeof scopeHierarchy] || 0;
    const requiredLevel = scopeHierarchy[requiredScope];

    if (tokenScopeLevel < requiredLevel) {
      return c.json({ 
        error: `Insufficient permissions. Required scope: ${requiredScope}, your scope: ${apiToken.scope}` 
      }, 403);
    }

    await next();
  };
};
