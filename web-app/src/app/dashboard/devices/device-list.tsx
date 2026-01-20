"use client";

import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger
} from '@/components/ui/alert-dialog';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger
} from '@/components/ui/dialog';
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuSeparator,
    DropdownMenuTrigger
} from '@/components/ui/dropdown-menu';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { createClient } from '@/utils/supabase/client';
import {
    Copy,
    History as HistoryIcon,
    Key,
    Loader2,
    MoreVertical,
    Plus,
    Settings2,
    Trash2,
    Truck,
    Wifi
} from 'lucide-react';
import Link from 'next/link';
import { useState } from 'react';
import { toast } from 'sonner';
import { useTranslations } from 'next-intl';

interface Device {
    id: string;
    device_id: string;
    device_name: string;
    secret_key: string;
    is_enabled: boolean;
    last_seen_at: string | null;
}

interface DeviceListProps {
  initialDevices: Device[];
  userId: string;
}

export function DeviceList({ initialDevices }: Omit<DeviceListProps, 'userId'>) {
    const [devices, setDevices] = useState<Device[]>(initialDevices);
    const supabase = createClient();
    const t = useTranslations();
    const [isAddOpen, setIsAddOpen] = useState(false);
    const [isEditOpen, setIsEditOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const [selectedDevice, setSelectedDevice] = useState<Device | null>(null);

    const [newDeviceId, setNewDeviceId] = useState('');
    const [newDeviceName, setNewDeviceName] = useState('');

    const handleAddDevice = async () => {
        if (!newDeviceId || !newDeviceName) {
            toast.error(t('common.required'));
            return;
        }

        setLoading(true);
        try {
            // Generate a random secret key for the device
            const secretKey = 'sk_' + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
            
            const { data, error } = await supabase
                .from('devices')
                .insert({
                    device_id: newDeviceId,
                    device_name: newDeviceName,
                    secret_key: secretKey,
                    is_enabled: true
                })
                .select()
                .single();

            if (error) throw error;

            setDevices([data, ...devices]);
            setIsAddOpen(false);
            setNewDeviceId('');
            setNewDeviceName('');
            toast.success(t('devices.registered'));
        } catch (error: unknown) {
             const err = error as Error;
            toast.error(err.message || t('common.error'));
        } finally {
            setLoading(false);
        }
    };

    const handleUpdateDevice = async () => {
        if (!selectedDevice || !newDeviceName) return;

        setLoading(true);
        try {
            const { error } = await supabase
                .from('devices')
                .update({ device_name: newDeviceName })
                .eq('id', selectedDevice.id);

            if (error) throw error;

            const updatedDevices = devices.map(d => 
                d.id === selectedDevice.id ? { ...d, device_name: newDeviceName } : d
            );
            setDevices(updatedDevices);
            setIsEditOpen(false);
            toast.success(t('devices.updated'));
        } catch (error: unknown) {
            const err = error as Error;
            toast.error(err.message || t('common.error'));
        } finally {
            setLoading(false);
        }
    };

    const handleDeleteDevice = async (id: string, name: string) => {
        try {
            const { error } = await supabase
                .from('devices')
                .delete()
                .eq('id', id);

            if (error) throw error;

            setDevices(devices.filter(d => d.id !== id));
            toast.success(`${name} ${t('devices.deleted')}`);
        } catch (error: unknown) {
            const err = error as Error;
            toast.error(err.message || t('common.error'));
        }
    };

    const toggleStatus = async (id: string, currentStatus: boolean) => {
        try {
            const { error } = await supabase
                .from('devices')
                .update({ is_enabled: !currentStatus })
                .eq('id', id);

            if (error) throw error;

            setDevices(devices.map(d => 
                d.id === id ? { ...d, is_enabled: !currentStatus } : d
            ));
            toast.success(currentStatus ? t('devices.disabled') : t('devices.enabled'));
        } catch (error: unknown) {
            const err = error as Error;
            toast.error(err.message || "Failed to update status");
        }
    };

    const copyKey = (key: string) => {
        navigator.clipboard.writeText(key);
        toast.success(t('devices.copy_secret'));
    };
    
    // ... (inside handlePingDevice)
    const handlePingDevice = async (deviceId: string) => {
        try {
            const response = await supabase
                .from('devices')
                .update({ last_seen_at: new Date().toISOString() })
                .eq('id', deviceId);

            if (response.error) throw response.error;

            toast.success(t('devices.ping'));
        } catch (error: unknown) {
            const err = error as Error;
            toast.error(err.message || "Failed to send ping");
        }
    };

    return (
        <div className="space-y-8">
            <div className="flex justify-end">
                <Dialog open={isAddOpen} onOpenChange={setIsAddOpen}>
                    <DialogTrigger asChild>
                        <Button className="bg-primary hover:bg-primary/90 text-white shadow-lg shadow-primary/20 px-6 rounded-md">
                            <Plus className="w-5 h-5 mr-2" />
                            {t('devices.registerUnit')}
                        </Button>
                    </DialogTrigger>
                    <DialogContent>
                        <DialogHeader>
                            <DialogTitle>{t('devices.registerNewUnit')}</DialogTitle>
                            <DialogDescription>
                                {t('devices.registerDescription')}
                            </DialogDescription>
                        </DialogHeader>
                        <div className="grid gap-6 py-6">
                            <div className="grid gap-2">
                                <Label htmlFor="device-id">Hardware Terminal ID</Label>
                                <Input 
                                    id="device-id" 
                                    placeholder="e.g. TRUCK-001" 
                                    value={newDeviceId}
                                    onChange={(e) => setNewDeviceId(e.target.value)}
                                />
                            </div>
                            <div className="grid gap-2">
                                <Label htmlFor="device-id">{t('devices.hardwareId')}</Label>
                                <Input 
                                    id="device-name" 
                                    placeholder="e.g. Delivery Van Paris" 
                                    value={newDeviceName}
                                    onChange={(e) => setNewDeviceName(e.target.value)}
                                />
                            </div>
                        </div>
                        <DialogFooter>
                            <Button variant="ghost" onClick={() => setIsAddOpen(false)}>{t('common.cancel')}</Button>
                            <Button onClick={handleAddDevice} disabled={loading} className="bg-primary hover:bg-primary/90 text-primary-foreground">
                                {loading && <Loader2 className="h-4 w-4 animate-spin mr-2" />}
                                {t('devices.addDevice')}
                            </Button>
                        </DialogFooter>
                    </DialogContent>
                </Dialog>
            </div>

            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                {devices.map((device) => (
                    <Card key={device.id} className={`relative overflow-hidden group transition-all border-border hover:border-primary/30 ${!device.is_enabled && 'opacity-70'}`}>
                        <CardHeader className="pb-4 border-b">
                            <div className="flex items-start justify-between relative z-10">
                                <div className="space-y-1">
                                    <CardTitle className="text-xl flex items-center gap-2">
                                        {device.device_name}
                                        {device.last_seen_at && (
                                            <span className="flex h-2 w-2 rounded-full bg-green-500 animate-pulse" />
                                        )}
                                    </CardTitle>
                                    <div className="flex items-center gap-2 text-muted-foreground font-mono text-[10px] tracking-widest uppercase">
                                        <Truck className="w-3 h-3" />
                                        {device.device_id}
                                    </div>
                                </div>
                                
                                <DropdownMenu>
                                    <DropdownMenuTrigger asChild>
                                        <Button variant="ghost" size="icon" className="h-8 w-8 text-muted-foreground hover:text-foreground">
                                            <MoreVertical className="w-4 h-4" />
                                        </Button>
                                    </DropdownMenuTrigger>
                                    <DropdownMenuContent align="end" className="w-56">
                                        <DropdownMenuItem onClick={() => copyKey(device.secret_key)} className="py-2.5">
                                            <Key className="w-4 h-4 mr-3 text-primary" />
                                            <span>{t('devices.copy_secret')}</span>
                                        </DropdownMenuItem>
                                        <DropdownMenuItem 
                                          onClick={() => {
                                            setSelectedDevice(device);
                                            setNewDeviceName(device.device_name);
                                            setIsEditOpen(true);
                                          }}
                                          className="py-2.5"
                                        >
                                            <Settings2 className="w-4 h-4 mr-3 text-blue-500" />
                                            <span>{t('devices.editDetails')}</span>
                                        </DropdownMenuItem>
                                        <DropdownMenuSeparator />
                                        
                                        <AlertDialog>
                                            <AlertDialogTrigger asChild>
                                                <div className="flex items-center px-2 py-2.5 text-sm text-red-500 hover:bg-red-500/10 cursor-pointer rounded-md">
                                                    <Trash2 className="w-4 h-4 mr-3" />
                                                    <span>{t('devices.removeDevice')}</span>
                                                </div>
                                            </AlertDialogTrigger>
                                            <AlertDialogContent>
                                                <AlertDialogHeader>
                                                    <AlertDialogTitle>{t('devices.deleteConfirmTitle')}</AlertDialogTitle>
                                                    <AlertDialogDescription>
                                                        {t('devices.deleteConfirmMessage')} 
                                                        <span className="text-foreground font-bold"> {device.device_name}</span>?
                                                    </AlertDialogDescription>
                                                </AlertDialogHeader>
                                                <AlertDialogFooter>
                                                    <AlertDialogCancel>{t('common.cancel')}</AlertDialogCancel>
                                                    <AlertDialogAction 
                                                        onClick={() => handleDeleteDevice(device.id, device.device_name)}
                                                        className="bg-red-600 hover:bg-red-700 text-white"
                                                    >
                                                        {t('common.confirmDelete')}
                                                    </AlertDialogAction>
                                                </AlertDialogFooter>
                                            </AlertDialogContent>
                                        </AlertDialog>
                                    </DropdownMenuContent>
                                </DropdownMenu>
                            </div>
                        </CardHeader>

                        <CardContent className="pt-6 relative z-10">
                            <div className="space-y-6">
                                <div className="flex items-center justify-between">
                                    <div className="space-y-0.5">
                                        <p className="text-xs text-muted-foreground font-medium uppercase tracking-tighter">{t('devices.transmissionStatus')}</p>
                                        <span className={`text-sm font-bold ${device.is_enabled ? "text-green-500" : "text-muted-foreground"}`}>
                                            {device.is_enabled ? t('devices.status_active') : t('devices.status_disabled')}
                                        </span>
                                    </div>
                                    <Switch 
                                        checked={device.is_enabled} 
                                        onCheckedChange={() => toggleStatus(device.id, device.is_enabled)}
                                        className="data-[state=checked]:bg-primary"
                                    />
                                </div>

                                <div className="flex items-center justify-between p-3 rounded-xl bg-muted/50 border border-border">
                                    <div className="space-y-0.5">
                                        <p className="text-[10px] text-muted-foreground uppercase font-bold">{t('devices.heartbeat')}</p>
                                        <p className="text-xs font-medium">
                                            {device.last_seen_at ? `${t('devices.synced')} ${new Date(device.last_seen_at).toLocaleTimeString()}` : t('devices.no_signal')}
                                        </p>
                                    </div>
                                    <div className="flex gap-2">
                                        <Button 
                                            size="icon" 
                                            variant="ghost" 
                                            className="h-8 w-8 text-primary hover:bg-primary/10"
                                            onClick={() => handlePingDevice(device.id)}
                                        >
                                            <Wifi className="h-4 w-4" />
                                        </Button>
                                    </div>
                                </div>

                                <div className="flex gap-2 pt-2">
                                    <Button asChild variant="outline" className="flex-1 text-[11px] h-9">
                                        <Link href="/dashboard/history">
                                            <HistoryIcon className="w-3 h-3 mr-2" /> {t('devices.log_history')}
                                        </Link>
                                    </Button>
                                    <Button 
                                        variant="outline" 
                                        className="flex-1 text-[11px] h-9"
                                        onClick={() => copyKey(device.secret_key)}
                                    >
                                        <Copy className="w-3 h-3 mr-2 text-primary" /> {t('devices.copy_secret')}
                                    </Button>
                                </div>
                            </div>
                        </CardContent>
                    </Card>
                ))}
            </div>

            <Dialog open={isEditOpen} onOpenChange={setIsEditOpen}>
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>{t('devices.editDeviceDetails')}</DialogTitle>
                    </DialogHeader>
                    <div className="grid gap-6 py-6">
                        <div className="grid gap-2">
                            <Label htmlFor="edit-name">{t('devices.displayName')}</Label>
                            <Input 
                                id="edit-name" 
                                value={newDeviceName}
                                onChange={(e) => setNewDeviceName(e.target.value)}
                            />
                        </div>
                    </div>
                    <DialogFooter>
                        <Button variant="ghost" onClick={() => setIsEditOpen(false)}>{t('common.cancel')}</Button>
                        <Button onClick={handleUpdateDevice} disabled={loading} className="bg-primary hover:bg-primary/90 text-primary-foreground">
                            {loading && <Loader2 className="h-4 w-4 animate-spin mr-2" />}
                            {t('common.save')}
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>
        </div>
    );
}
