"use client";

import { useEffect, useState, useRef } from 'react';
import { createClient } from '@/utils/supabase/client';
import { useRouter } from 'next/navigation';
import MapView from '@/components/map/map-view';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Truck, Signal } from 'lucide-react';
import { useTranslations } from 'next-intl';

interface Position {
  latitude: number;
  longitude: number;
  speed: number;
  recorded_at: string;
}

interface TrackingDevice {
  id: string;
  device_id: string;
  device_name: string;
  is_enabled: boolean;
  last_seen_at: string | null;
  positions: Position[];
}

export default function TrackingPage() {
    const supabase = createClient();
    const router = useRouter();
    const t = useTranslations();
    const [devices, setDevices] = useState<TrackingDevice[]>([]);
    const [loading, setLoading] = useState(true);
    const [isFullscreen, setIsFullscreen] = useState(false);
    const [currentTime, setCurrentTime] = useState(new Date());
    const mapRef = useRef<{ centerMap: (lat: number, lng: number) => void } | null>(null);

    useEffect(() => {
        const timer = setInterval(() => setCurrentTime(new Date()), 30000); // Update every 30s
        return () => clearInterval(timer);
    }, []);

    useEffect(() => {
        const fetchDevices = async () => {
            const { data: { user } } = await supabase.auth.getUser();

            if (!user) {
                router.push('/login');
                return;
            }

            const { data, error } = await supabase
                .from('devices')
                .select(`
                    id,
                    device_id,
                    device_name,
                    is_enabled,
                    last_seen_at,
                    positions (
                        latitude,
                        longitude,
                        speed,
                        recorded_at
                    )
                `)
                .eq('is_enabled', true)
                .order('last_seen_at', { ascending: false });

            if (error) {
                console.error('Error fetching tracking data:', error);
            } else {
                interface DeviceResponse {
                    id: string;
                    device_id: string;
                    device_name: string;
                    is_enabled: boolean;
                    last_seen_at: string | null;
                    positions: {
                        latitude: number;
                        longitude: number;
                        speed: number;
                        recorded_at: string;
                    }[];
                }

                const devicesWithSortedPositions = ((data as unknown as DeviceResponse[]) || []).map((d) => ({
                    ...d,
                    positions: d.positions?.sort((a, b: { recorded_at: string }) => 
                        new Date(b.recorded_at).getTime() - new Date(a.recorded_at).getTime()
                    ) || []
                }));
                setDevices(devicesWithSortedPositions);
            }
            setLoading(false);
        };

        fetchDevices();

        const channel = supabase
            .channel('realtime-positions')
            .on('postgres_changes', {
                event: 'INSERT',
                schema: 'public',
                table: 'positions'
            }, (payload) => {
                const newPos = payload.new;
                
                setDevices((currentDevices) => {
                    return currentDevices.map(device => {
                        if (device.id === newPos.device_id) {
                            return {
                                ...device,
                                last_seen_at: newPos.recorded_at,
                                positions: [
                                    {
                                        latitude: newPos.latitude,
                                        longitude: newPos.longitude,
                                        speed: newPos.speed,
                                        recorded_at: newPos.recorded_at
                                    },
                                    ...(device.positions || [])
                                ]
                            };
                        }
                        return device;
                    });
                });
            })
            .subscribe();

        return () => {
            supabase.removeChannel(channel);
        };
    }, [supabase, router]);

    // Process devices to get markers with dynamic status
    const markers = devices
        .filter(d => d.positions && d.positions.length > 0)
        .map(d => {
            const latestPos = d.positions[0];
            const lastSeen = new Date(d.last_seen_at || latestPos.recorded_at);
            const diffMinutes = (currentTime.getTime() - lastSeen.getTime()) / (1000 * 60);
            
            let status = 'stationary';
            if (diffMinutes > 5) {
                status = 'stationary';
            } else {
                status = latestPos.speed > 0.5 ? 'moving' : 'stationary';
            }

            return {
                id: d.id,
                name: d.device_name,
                lat: latestPos.latitude,
                lng: latestPos.longitude,
                status
            };
        });

    const handleDeviceClick = (device: TrackingDevice) => {
        if (device.positions && device.positions.length > 0) {
            const latestPos = device.positions[0];
            if (mapRef.current) {
                mapRef.current.centerMap(latestPos.latitude, latestPos.longitude);
            }
        }
    };

    return (
        <div className={`space-y-6 flex flex-col pb-6 ${isFullscreen ? 'fixed inset-0 z-[100] bg-background p-6 h-screen w-screen transition-all' : 'h-[calc(100vh-140px)]'}`}>
            <div className="flex items-center justify-between">
                <div>
                    <h2 className="text-3xl font-bold tracking-tight">{t('tracking.title')}</h2>
                    <p className="text-muted-foreground flex items-center gap-2">
                        <Signal className="w-3 h-3 text-green-500 animate-ping" />
                        {t('tracking.synchronized')}
                    </p>
                </div>
                <div className="flex gap-2 items-center">
                    <Badge variant="outline" className="dark:bg-zinc-900 dark:border-zinc-800 dark:text-zinc-400 bg-primary/10">
                        {t('tracking.active_units')}: {markers.length}
                    </Badge>
                    <Button 
                      variant="outline" 
                      size="icon" 
                      onClick={() => setIsFullscreen(!isFullscreen)}
                      className="rounded-full h-10 w-10 border-border bg-card/50 backdrop-blur-sm"
                    >
                      {isFullscreen ? (
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="h-4 w-4"><path d="M4 14h6v6"/><path d="M20 10h-6V4"/><path d="m14 10 6-6"/><path d="m10 14-6 6"/></svg>
                      ) : (
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="h-4 w-4"><path d="m15 3 6 6"/><path d="m9 21-6-6"/><path d="M21 3v6h-6"/><path d="M3 21v-6h6"/><path d="m21 3-6.7 6.7"/><path d="m3 21 6.7-6.7"/></svg>
                      )}
                    </Button>
                </div>
            </div>

            <div className={`grid gap-6 flex-1 min-h-0 ${isFullscreen ? 'lg:grid-cols-5' : 'lg:grid-cols-4'}`}>
                <Card className={`${isFullscreen ? 'lg:col-span-4' : 'lg:col-span-3'} dark:border-zinc-900 darb:bg-zinc-950 bg:primary/30 overflow-hidden relative border-border shadow-2xl shadow-primary/5`}>
                    <MapView ref={mapRef} markers={markers.length > 0 ? markers : []} />
                </Card>

                <Card className="lg:col-span-1 dark:border-zinc-900 dark:bg-zinc-950/50 backdrop-blur-md overflow-hidden flex flex-col border-border">
                    <CardHeader className="dark:border-b dark:border-zinc-900/50 dark:bg-zinc-900/20">
                        <CardTitle className="text-sm uppercase tracking-widest text-zinc-500">{t('tracking.fleet_overview')}</CardTitle>
                    </CardHeader>
                    <CardContent className="flex-1 overflow-y-auto p-0 scrollbar-hide">
                        <div className="divide-y dark:divide-zinc-900">
                            {devices.map((device) => {
                                const latestPos = device.positions?.[0];
                                const lastSeen = latestPos ? new Date(device.last_seen_at || latestPos.recorded_at) : null;
                                const isInactive = lastSeen ? (currentTime.getTime() - lastSeen.getTime()) / (1000 * 60) > 5 : true;
                                const isMoving = latestPos && latestPos.speed > 0.5 && !isInactive;

                                return (
                                    <div 
                                        key={device.id} 
                                        onClick={() => handleDeviceClick(device)}
                                        className="p-4 dark:hover:bg-zinc-900/50 hover:bg-primary/5 transition-colors group cursor-pointer"
                                    >
                                        <div className="flex items-start justify-between mb-2">
                                            <div className="flex items-center gap-3">
                                                <div className={`p-2 rounded-lg border dark:border-zinc-800 transition-colors ${isMoving ? 'bg-green-500/10 border-green-500/50' : 'bg-zinc-900 border-zinc-800'}`}>
                                                    <Truck className={`w-4 h-4 ${isMoving ? 'text-green-500' : 'text-zinc-500'}`} />
                                                </div>
                                                <div>
                                                    <p className="text-sm font-bold dark:text-zinc-200">{device.device_name}</p>
                                                    <p className="text-[10px] font-mono dark:text-zinc-500">{device.device_id}</p>
                                                </div>
                                            </div>
                                            <div className={`h-2 w-2 rounded-full ${isInactive ? 'bg-zinc-600' : (isMoving ? 'bg-green-500' : 'bg-orange-500')}`} />
                                        </div>
                                        <div className="flex items-center justify-between mt-4">
                                            <div className="space-y-0.5">
                                                <p className="text-[9px] uppercase font-bold text-zinc-600">Last seen</p>
                                                <p className="text-[10px] dark:text-zinc-400">
                                                    {lastSeen ? lastSeen.toLocaleTimeString() : 'Never'}
                                                </p>
                                            </div>
                                            <div className="text-right">
                                                <p className="text-[9px] uppercase font-bold text-zinc-600">Status</p>
                                                <p className={`text-[10px] font-bold ${isMoving ? 'text-green-500' : (isInactive ? 'text-zinc-500' : 'text-orange-500')}`}>
                                                    {isInactive ? 'Inactive' : (isMoving ? `${(latestPos?.speed || 0).toFixed(1)} km/h` : 'Stopped')}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                );
                            })}
                            {devices.length === 0 && (
                                <div className="p-8 text-center text-zinc-600 text-xs italic">
                                    {loading ? 'Loading units...' : 'No active units detected.'}
                                </div>
                            )}
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>
    );
}
