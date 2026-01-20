import { createClient } from '@/utils/supabase/server';
import { redirect } from 'next/navigation';
import { DeviceList } from './device-list';

import { getTranslations } from 'next-intl/server';

export default async function DevicesPage() {
    const supabase = await createClient();
    const t = await getTranslations();

    const {
        data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
        redirect('/login');
    }

    const { data: devices, error } = await supabase
        .from('devices')
        .select('*')
        .order('created_at', { ascending: false });

    if (error) {
        console.error('Error fetching devices:', error);
    }

    return (
        <div className="space-y-8 pb-20">
            <div className="flex items-center justify-between">
                <div className="space-y-1">
                    <h2 className="text-3xl font-bold tracking-tight">{t('devices.title')}</h2>
                    <p className="text-muted-foreground">{t('devices.monitor_description')}</p>
                </div>
            </div>

            <DeviceList initialDevices={devices || []} />
        </div>
    );
}
