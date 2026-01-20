import { createClient } from '@/utils/supabase/server';
import { NextRequest, NextResponse } from 'next/server';
import { supabaseAdmin } from '@/lib/supabase';

export const dynamic = 'force-dynamic';

// Create API token
export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await request.json();
    const { name, scope = 'read' } = body;

    if (!name) {
      return NextResponse.json({ error: 'Missing required field: name' }, { status: 400 });
    }

    if (!['read', 'read-write', 'admin'].includes(scope)) {
      return NextResponse.json({ error: 'Invalid scope. Must be: read, read-write, or admin' }, { status: 400 });
    }

    // Generate token
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let tokenValue = '';
    for (let i = 0; i < 32; i++) {
      tokenValue += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    const token = `ft_${tokenValue}`;

    // Insert token using admin client (bypasses RLS)
    const { data, error } = await supabaseAdmin
      .from('api_tokens')
      .insert({
        user_id: user.id,
        name,
        token,
        scope,
      })
      .select()
      .single();

    if (error) {
      console.error('Error creating token:', error);
      return NextResponse.json({ error: 'Failed to create token' }, { status: 500 });
    }

    return NextResponse.json({ data }, { status: 201 });
  } catch (error) {
    console.error('Error:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}

// List user's API tokens
export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { data, error } = await supabaseAdmin
      .from('api_tokens')
      .select('id, name, token, scope, created_at, last_used_at')
      .eq('user_id', user.id)
      .order('created_at', { ascending: false });

    if (error) {
      return NextResponse.json({ error: 'Failed to fetch tokens' }, { status: 500 });
    }

    return NextResponse.json({ data: data || [] });
  } catch (error) {
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}
