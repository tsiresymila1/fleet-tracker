"use client";

import dynamic from 'next/dynamic';

const IntegrationRelay = dynamic(() => import('@/components/integration-relay').then(mod => mod.IntegrationRelay), { 
  ssr: false,
  loading: () => (
    <div className="h-[200px] w-full bg-muted animate-pulse rounded-xl border border-border flex items-center justify-center">
      <div className="text-[10px] text-muted-foreground uppercase tracking-widest italic">Initializing Uplink...</div>
    </div>
  )
});
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { createClient } from '@/utils/supabase/client';
import {
  Activity,
  AlertTriangle,
  Clock,
  MapPin,
  Navigation,
  Truck
} from 'lucide-react';
import { useTranslations } from 'next-intl';
import Link from 'next/link';
import { useEffect, useState } from 'react';

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

interface DashboardClientProps {
  stats: {
    totalDistance: string;
    activeCount: string;
    telemetryPoints: string;
  };
  recentActivity: ActivityItem[];
  userEmail: string;
  profileName?: string;
}

export default function DashboardClient({
  stats: initialStats,
  recentActivity: initialActivity,
  userEmail,
  profileName
}: DashboardClientProps) {
  const supabase = createClient();
  const t = useTranslations();
  const [stats, setStats] = useState(initialStats);
  const [recentActivity, setRecentActivity] = useState(initialActivity);
  const [systemStatus, setSystemStatus] = useState('OPTIMAL');


  const refreshStats = async () => {
    try {
      const { count: totalPositions } = await supabase
        .from('positions')
        .select('*', { count: 'exact', head: true });

      const { count: activeCount } = await supabase
        .from('devices')
        .select('*', { count: 'exact', head: true })
        .eq('is_enabled', true);

      setStats({
        totalDistance: `${((totalPositions || 0) * 0.5).toFixed(1)} km`,
        activeCount: (activeCount || 0).toString(),
        telemetryPoints: (totalPositions || 0).toLocaleString(),
      });
    } catch (error) {
      console.error('Error refreshing stats:', error);
    }
  };

  const statsList = [
    {
      title: t('dashboard.totalDistance'),
      value: stats.totalDistance,
      change: "+12.5%",
      icon: Navigation,
      color: "text-blue-500",
      bg: "bg-blue-500/10"
    },
    {
      title: t('dashboard.activeDevices'),
      value: stats.activeCount,
      change: t('dashboard.liveNow'),
      icon: Truck,
      color: "text-primary",
      bg: "bg-primary/10"
    },
    {
      title: t('dashboard.telemetryPoints'),
      value: stats.telemetryPoints,
      change: t('dashboard.uplinkSecure'),
      icon: Activity,
      color: "text-green-500",
      bg: "bg-green-500/10"
    },
    {
      title: t('dashboard.activeAlerts'),
      value: "0",
      change: t('dashboard.noIssues'),
      icon: AlertTriangle,
      color: "text-orange-500",
      bg: "bg-orange-500/10"
    },
  ];


  useEffect(() => {
    // Subscribe to position updates
    const positionsSubscription = supabase
      .channel('positions')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'positions'
        },
        () => {
          // Update system status on new data
          setSystemStatus('OPTIMAL');
          // Refresh stats
          refreshStats();
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(positionsSubscription);
    };
  }, [supabase]);

  return (
    <div className="space-y-8 pb-20">
      {/* Welcome Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-extrabold tracking-tight">{t('dashboard.terminalOverview')}</h1>
          <p className="text-muted-foreground italic">{t('dashboard.welcomeBack')} <span className="text-primary font-bold">{profileName || userEmail.split('@')[0]}</span>. {t('dashboard.satelliteLink')}</p>
        </div>
        <div className="flex items-center gap-2 text-xs font-mono bg-muted px-4 py-2 rounded-full border border-border">
          <span className="h-2 w-2 rounded-full bg-green-500 animate-pulse" />
          {t('dashboard.systemStatus')}: {systemStatus}
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        {statsList.map((stat) => (
          <Card key={stat.title} className="border-border hover:border-muted-foreground/20 transition-all group">
            <CardHeader className="flex flex-row items-center justify-between pb-2 space-y-0">
              <CardTitle className="text-sm font-medium text-muted-foreground">{stat.title}</CardTitle>
              <div className={`${stat.bg} ${stat.color} p-2 rounded-lg group-hover:scale-110 transition-transform`}>
                <stat.icon className="h-4 w-4" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stat.value}</div>
              <p className="text-[10px] text-muted-foreground font-bold uppercase tracking-widest mt-1">
                {stat.change}
              </p>
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid gap-6 lg:grid-cols-7">
        {/* Main Feed */}
        <Card className="lg:col-span-4 border-border">
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle>{t('dashboard.globalActivityFeed')}</CardTitle>
                <CardDescription>{t('dashboard.liveTelemetryStream')}</CardDescription>
              </div>
              <Button size="icon" variant="ghost" className="text-muted-foreground">
                <Clock className="h-4 w-4" />
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            <div className="space-y-8">
              {recentActivity.map((item, i) => (
                <div key={item.id} className="flex items-center gap-4 group">
                  <div className="relative">
                    <div className="bg-muted p-2.5 rounded-xl border border-border group-hover:bg-primary transition-colors">
                      <MapPin className="h-4 w-4 text-muted-foreground group-hover:text-primary-foreground" />
                    </div>
                    {i !== 4 && <div className="absolute top-10 left-1/2 w-0.5 h-10 bg-border -translate-x-1/2" />}
                  </div>
                  <div className="flex-1 space-y-1">
                    <p className="text-sm font-bold text-foreground">
                      {item.devices?.device_name} <span className="text-muted-foreground font-normal">{t('dashboard.reportedPosition')}</span>
                    </p>
                    <div className="flex items-center gap-2 text-[10px] font-mono text-muted-foreground uppercase tracking-tighter">
                      <span>{item.latitude.toFixed(4)}N, {item.longitude.toFixed(4)}E</span>
                      <span>•</span>
                      <span>{item.speed} KM/H</span>
                    </div>
                  </div>
                  <div className="text-[10px] text-muted-foreground font-bold">
                    {new Date(item.recorded_at).toLocaleTimeString()}
                  </div>
                </div>
              ))}
              {recentActivity.length === 0 && (
                <div className="py-10 text-center text-muted-foreground text-sm">
                  {t('dashboard.waitingForSignal')}
                </div>
              )}
            </div>
            <Button asChild variant="outline" className="w-full mt-8 border-border bg-muted/30 hover:bg-muted">
              <Link href="/dashboard/history">{t('dashboard.viewDetailedLogs')}</Link>
            </Button>
          </CardContent>
        </Card>

        {/* Quick Actions / Integration */}
        <Card className="lg:col-span-3 border-border">
          <CardHeader>
            <CardTitle>{t('dashboard.integrationRelay')}</CardTitle>
            <CardDescription>{t('dashboard.directUplink')}</CardDescription>
          </CardHeader>
          <CardContent>
            <IntegrationRelay />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
