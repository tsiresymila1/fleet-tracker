import { createClient } from '@/utils/supabase/server';
import { redirect } from 'next/navigation';
import { HistoryTable } from './history-table';
import { getTranslations } from 'next-intl/server';

interface HistoryRecord {
  id: string;
  latitude: number;
  longitude: number;
  speed: number;
  recorded_at: string;
  devices: {
    device_name: string;
    device_id: string;
  } | null;
}

interface HistoryPageProps {
  searchParams?: { [key: string]: string | string[] | undefined };
}

export default async function HistoryPage({ searchParams }: HistoryPageProps) {
  const supabase = await createClient();
  const t = await getTranslations();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect('/login');
  }

  // Pagination params
  const params = await searchParams;
  const page = params?.page ? parseInt(params.page as string) : 1;
  const pageSize = 15;
  const start = (page - 1) * pageSize;
  const end = start + pageSize - 1;

  // Fetch recent positions with device names and pagination
  const { data, error, count } = await supabase
    .from('positions')
    .select(`
      id,
      latitude,
      longitude,
      speed,
      recorded_at,
      devices (
        device_name,
        device_id
      )
    `, { count: 'exact' })
    .order('recorded_at', { ascending: false })
    .range(start, end);

  const history = data as unknown as HistoryRecord[] | null;

  if (error) {
    console.error('Error fetching history:', error);
  }

  // Format data for the chart/table
  const formattedHistory = (history || []).map((p) => ({
    id: p.id,
    device: p.devices?.device_name || 'Unknown',
    time: new Date(p.recorded_at).toLocaleString(),
    location: `${p.latitude.toFixed(4)}° N, ${p.longitude.toFixed(4)}° E`,
    speed: `${p.speed} km/h`,
    status: p.speed > 0 ? 'moving' : 'stopped',
    // Raw data for trajectory
    latitude: p.latitude,
    longitude: p.longitude,
    recorded_at: p.recorded_at
  }));

  return (
    <div className="space-y-6 pb-20">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-3xl font-bold tracking-tight">{t('history.title')}</h1>
          <p className="text-muted-foreground italic">{t('history.telemetry')}</p>
        </div>
      </div>

      <HistoryTable 
        initialData={formattedHistory} 
        currentPage={page}
        totalPages={Math.ceil((count || 0) / pageSize)}
        totalCount={count || 0}
      />
    </div>
  );
}
