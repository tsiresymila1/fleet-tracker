"use client";

import { useEffect, useState, useRef } from 'react';
import { createClient } from '@/utils/supabase/client';
import { useRouter } from 'next/navigation';
import MapView from '@/components/map/map-view';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
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
    const mapRef = useRef<{ centerMap: (lat: number, lng: number) => void } | null>(null);

    useEffect(() => {
        const fetchDevices = async () => {
            const { data: { user } } = await supabase.auth.getUser();

            if (!user) {
                router.push('/login');
                return;
            }

            // Fetch latest position for each active device
            // Note: In a real app, you'd want to limit the nested positions query
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
                // Sort positions for each device to ensure latest is first (if multiple returned)
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

                // Sort positions for each device to ensure latest is first (if multiple returned)
                const devicesWithSortedPositions = ((data as unknown as DeviceResponse[]) || []).map((d) => ({
                    ...d,
                    positions: d.positions?.sort((a, b) => 
                        new Date(b.recorded_at).getTime() - new Date(a.recorded_at).getTime()
                    ) || []
                }));
                setDevices(devicesWithSortedPositions);
            }
            setLoading(false);
        };

        fetchDevices();

        // Realtime Subscription
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

    // Process devices to get markers
    const markers = devices
        .filter(d => d.positions && d.positions.length > 0)
        .map(d => {
            const latestPos = d.positions[0];
            return {
                id: d.id,
                name: d.device_name,
                lat: latestPos.latitude,
                lng: latestPos.longitude,
                status: latestPos.speed > 0 ? 'moving' : 'stationary'
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
        <div className="space-y-6 h-[calc(100vh-140px)] flex flex-col pb-6">
            <div className="flex items-center justify-between">
                <div>
                    <h2 className="text-3xl font-bold tracking-tight">{t('tracking.title')}</h2>
                    <p className="text-muted-foreground flex items-center gap-2">
                        <Signal className="w-3 h-3 text-green-500 animate-ping" />
                        {t('tracking.synchronized')}
                    </p>
                </div>
                <div className="flex gap-2">
                    <Badge variant="outline" className="dark:bg-zinc-900 dark:border-zinc-800 dark:text-zinc-400 bg-primary/50">
                        {t('tracking.active_units')}: {markers.length}
                    </Badge>
                </div>
            </div>

            <div className="grid lg:grid-cols-4 gap-6 flex-1 min-h-0">
                <Card className="lg:col-span-3 dark:border-zinc-900 darb:bg-zinc-950 bg:primary/30 overflow-hidden relative">
                    <MapView ref={mapRef} markers={markers.length > 0 ? markers : []} />
                </Card>

                <Card className="lg:col-span-1 dark:border-zinc-900 dark:bg-zinc-950/50 backdrop-blur-md overflow-hidden flex flex-col">
                    <CardHeader className="dark:border-b dark:border-zinc-900/50 dark:bg-zinc-900/20">
                        <CardTitle className="text-sm uppercase tracking-widest text-zinc-500">{t('tracking.fleet_overview')}</CardTitle>
                    </CardHeader>
                    <CardContent className="flex-1 overflow-y-auto p-0 scrollbar-thin scrollbar-thumb-zinc-800">
                        <div className="divide-y dark:divide-zinc-900">
                            {devices.map((device) => (
                                <div 
                                    key={device.id} 
                                    onClick={() => handleDeviceClick(device)}
                                    className="p-4 dark:hover:bg-zinc-900/50 hover:bg-primary/20 transition-colors group cursor-pointer"
                                >
                                    <div className="flex items-start justify-between mb-2">
                                        <div className="flex items-center gap-3">
                                            <div className="dark:bg-zinc-900 p-2 rounded-lg border dark:border-zinc-800 group-hover:border-primary/50">
                                                <Truck className="w-4 h-4 text-zinc-500 group-hover:text-primary" />
                                            </div>
                                            <div>
                                                <p className="text-sm font-bold dark:text-zinc-200">{device.device_name}</p>
                                                <p className="text-[10px] font-mono dark:text-zinc-500">{device.device_id}</p>
                                            </div>
                                        </div>
                                        <div className={`h-2 w-2 rounded-full ${device.is_enabled ? 'bg-green-500' : 'bg-zinc-700'}`} />
                                    </div>
                                    <div className="flex items-center justify-between mt-4">
                                        <div className="space-y-0.5">
                                            <p className="text-[9px] uppercase font-bold text-zinc-600">Last Fix</p>
                                            <p className="text-[10px] dark:text-zinc-400">
                                                {device.last_seen_at ? new Date(device.last_seen_at).toLocaleTimeString() : 'Never'}
                                            </p>
                                        </div>
                                        <div className="text-right">
                                            <p className="text-[9px] uppercase font-bold text-zinc-600">Speed</p>
                                            <p className="text-xs font-bold dark:text-zinc-200">
                                                {device.positions?.[0]?.speed || 0} km/h
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            ))}
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
