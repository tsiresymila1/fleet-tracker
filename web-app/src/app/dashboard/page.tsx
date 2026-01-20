import { createClient } from '@/utils/supabase/server';
import { redirect } from 'next/navigation';
import DashboardClient from './dashboard-client';

interface ActivityItem {
  id: string;
  recorded_at: string;
  speed: number;
  latitude: number;
  longitude: number;
  devices: {
    device_name: string;
  } | null;
}

interface Profile {
  full_name?: string;
}

export default async function DashboardPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect('/login');
  }

  // Fetch stats concurrently
  const [
    { count: activeCount },
    { count: totalPositions },
    { data: recentActivityRaw },
    { data: profile }
  ] = await Promise.all([
    supabase.from('devices').select('*', { count: 'exact', head: true }).eq('is_enabled', true),
    supabase.from('positions').select('*', { count: 'exact', head: true }),
    supabase.from('positions').select(`
      id, recorded_at, speed, latitude, longitude,
      devices (device_name)
    `).order('recorded_at', { ascending: false }).limit(5),
    supabase.from('profiles').select('*').eq('id', user.id).single()
  ]);

  const recentActivity = recentActivityRaw as unknown as ActivityItem[] | null;
  const profileData = profile as unknown as Profile | null;

  const stats = {
    totalDistance: `${((totalPositions || 0) * 0.5).toFixed(1)} km`,
    activeCount: (activeCount || 0).toString(),
    telemetryPoints: (totalPositions || 0).toLocaleString(),
  };

  return (
    <DashboardClient 
      stats={stats}
      recentActivity={recentActivity || []}
      userEmail={user.email || ''}
      profileName={profileData?.full_name}
    />
  );
}

