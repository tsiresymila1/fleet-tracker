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
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { DatePicker } from "@/components/ui/date-picker";
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { createClient } from '@/utils/supabase/client';
import { Trash2 } from "lucide-react";
import { useTranslations } from 'next-intl';
import { useEffect, useState } from 'react';
import { toast } from 'sonner';

interface PurgeDataDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    availableDevices: string[];
    onPurgeComplete: () => void;
}

export function PurgeDataDialog({
    open,
    onOpenChange,
    availableDevices,
    onPurgeComplete
}: PurgeDataDialogProps) {
    const t = useTranslations('history');
    const supabase = createClient();

    const [startDate, setStartDate] = useState<Date | undefined>(undefined);
    const [endDate, setEndDate] = useState<Date | undefined>(undefined);
    const [selectedDevices, setSelectedDevices] = useState<string[]>([]);
    const [showConfirmDialog, setShowConfirmDialog] = useState(false);
    const [isPurging, setIsPurging] = useState(false);

    const handleDeviceToggle = (device: string) => {
        setSelectedDevices(prev =>
            prev.includes(device)
                ? prev.filter(d => d !== device)
                : [...prev, device]
        );
    };

    const handleSelectAll = () => {
        if (selectedDevices.length === availableDevices.length) {
            setSelectedDevices([]);
        } else {
            setSelectedDevices(availableDevices);
        }
    };

    const resetForm = () => {
        setStartDate(undefined);
        setEndDate(undefined);
        setSelectedDevices([]);
    };

    // Reset form when dialog is closed
    useEffect(() => {
        if (!open) {
            resetForm();
        }
    }, [open]);

    const handlePurgeClick = () => {
        if (selectedDevices.length === 0) {
            toast.error(t('purge_select_device'));
            return;
        }
        setShowConfirmDialog(true);
    };

    const handleConfirmPurge = async () => {
        setIsPurging(true);
        setShowConfirmDialog(false);

        try {
            // First, get device table IDs (UUIDs) for the selected device names
            const { data: devices, error: deviceError } = await supabase
                .from('devices')
                .select('id')
                .in('device_name', selectedDevices);

            if (deviceError) {
                throw deviceError;
            }

            if (!devices || devices.length === 0) {
                toast.error(t('purge_no_devices_found'));
                return;
            }

            const deviceTableIds = devices.map(d => d.id);
            
            console.log('Attempting to delete positions for device IDs:', deviceTableIds);
            console.log('Date range:', { startDate, endDate });

            // Build the delete query with device table IDs (UUIDs)
            const deleteOptions = { count: 'exact' as const };
            let deleteQuery = supabase
                .from('positions')
                .delete(deleteOptions)
                .in('device_id', deviceTableIds);

            // Apply date filters
            if (startDate && endDate) {
                // Delete between start and end d d
                const endOfDay = new Date(endDate);
                endOfDay.setHours(23, 59, 59, 999);
                console.log('Deleting between:', startDate.toISOString(), 'and', endOfDay.toISOString());
                deleteQuery = deleteQuery
                    .gte('recorded_at', startDate.toISOString())
                    .lte('recorded_at', endOfDay.toISOString());
            } else if (startDate) {
                // Delete from start until now
                console.log('Deleting from:', startDate.toISOString());
                deleteQuery = deleteQuery.gte('recorded_at', startDate.toISOString());
            } else if (endDate) {
                // Delete data until end
                const endOfDay = new Date(endDate);
                endOfDay.setHours(23, 59, 59, 999);
                console.log('Deleting until:', endOfDay.toISOString());
                deleteQuery = deleteQuery.lte('recorded_at', endOfDay.toISOString());
            } else {
                console.log('Deleting all positions for selected devices');
            }

            const { error, count, data, status, statusText } = await deleteQuery;
        
            console.log('Delete result:', { error, count, data, status, statusText });

            if (error) {
                console.error('Delete error details:', error);
                throw error;
            }

            toast.success(t('purge_success', { count: count || 0 }));
            onPurgeComplete();
            onOpenChange(false);
            // Form will be reset by useEffect when dialog closes

        } catch (error: unknown) {
            console.error('Purge error:', error);
            if (error && typeof error === 'object' && 'message' in error) {
                toast.error(`${t('purge_error')}: ${(error as { message: string }).message}`);
            } else {
                toast.error(t('purge_error'));
            }
        } finally {
            setIsPurging(false);
        }
    };

    const getDateRangeDescription = () => {
        if (startDate && endDate) {
            return t('purge_between', {
                start: startDate.toLocaleDateString(),
                end: endDate.toLocaleDateString()
            });
        } else if (startDate) {
            return t('purge_from', { date: startDate.toLocaleDateString() });
        } else if (endDate) {
            return t('purge_until', { date: endDate.toLocaleDateString() });
        }
        return t('purge_all_time');
    };

    return (
        <>
            <Dialog open={open} onOpenChange={onOpenChange}>
                <DialogContent className="sm:max-w-[500px]">
                    <DialogHeader>
                        <DialogTitle className="flex items-center gap-2">
                            <Trash2 className="h-5 w-5 text-red-500" />
                            {t('purge_title')}
                        </DialogTitle>
                        <DialogDescription>
                            {t('purge_description')}
                        </DialogDescription>
                    </DialogHeader>

                    <div className="space-y-6 py-4">
                        {/* Device Selection */}
                        <div className="space-y-3">
                            <div className="flex items-center justify-between">
                                <Label className="text-sm font-semibold">{t('purge_select_devices')}</Label>
                                <Button
                                    variant="ghost"
                                    size="sm"
                                    onClick={handleSelectAll}
                                    className="h-8 text-xs"
                                >
                                    {selectedDevices.length === availableDevices.length
                                        ? t('purge_deselect_all')
                                        : t('purge_select_all')}
                                </Button>
                            </div>

                            <div className="border rounded-lg p-3 max-h-[200px] overflow-y-auto space-y-2">
                                {availableDevices.map((device) => (
                                    <div key={device} className="flex items-center space-x-2">
                                        <Checkbox
                                            id={`device-${device}`}
                                            checked={selectedDevices.includes(device)}
                                            onCheckedChange={() => handleDeviceToggle(device)}
                                        />
                                        <label
                                            htmlFor={`device-${device}`}
                                            className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 cursor-pointer"
                                        >
                                            {device}
                                        </label>
                                    </div>
                                ))}
                            </div>
                            <p className="text-xs text-muted-foreground">
                                {selectedDevices.length} {t('purge_devices_selected')}
                            </p>
                        </div>

                        {/* Date Range */}
                        <div className="space-y-3">
                            <Label className="text-sm font-semibold">{t('purge_date_range')}</Label>
                            <div className="grid grid-cols-2 gap-3">
                                <div className="space-y-2">
                                    <Label className="text-xs text-muted-foreground">{t('start_date')}</Label>
                                    <DatePicker
                                        date={startDate}
                                        onDateChange={setStartDate}
                                        placeholder={t('purge_optional')}
                                    />
                                </div>
                                <div className="space-y-2">
                                    <Label className="text-xs text-muted-foreground">{t('end_date')}</Label>
                                    <DatePicker
                                        date={endDate}
                                        onDateChange={setEndDate}
                                        placeholder={t('purge_optional')}
                                    />
                                </div>
                            </div>
                            <p className="text-xs text-muted-foreground">
                                {getDateRangeDescription()}
                            </p>
                        </div>
                    </div>

                    <DialogFooter>
                        <Button variant="outline" onClick={() => onOpenChange(false)}>
                            {t('purge_cancel')}
                        </Button>
                        <Button
                            variant="destructive"
                            onClick={handlePurgeClick}
                            disabled={selectedDevices.length === 0}
                        >
                            <Trash2 className="mr-2 h-4 w-4" />
                            {t('purge_button')}
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>

            {/* Confirmation Dialog */}
            <AlertDialog open={showConfirmDialog} onOpenChange={setShowConfirmDialog}>
                <AlertDialogContent>
                    <AlertDialogHeader>
                        <AlertDialogTitle className="text-red-600">
                            {t('purge_confirm_title')}
                        </AlertDialogTitle>
                        <AlertDialogDescription className="space-y-2">
                            <p>{t('purge_confirm_warning')}</p>
                            <div className="bg-muted p-3 rounded-lg space-y-1 text-sm">
                                <p><strong>{t('purge_devices')}:</strong> {selectedDevices.join(', ')}</p>
                                <p><strong>{t('purge_period')}:</strong> {getDateRangeDescription()}</p>
                            </div>
                            <p className="text-red-600 font-semibold">{t('purge_irreversible')}</p>
                        </AlertDialogDescription>
                    </AlertDialogHeader>
                    <AlertDialogFooter>
                        <AlertDialogCancel>{t('purge_cancel')}</AlertDialogCancel>
                        <AlertDialogAction
                            onClick={handleConfirmPurge}
                            disabled={isPurging}
                            className="bg-red-600 hover:bg-red-700 text-white"
                        >
                            {isPurging ? t('purge_processing') : t('purge_confirm')}
                        </AlertDialogAction>
                    </AlertDialogFooter>
                </AlertDialogContent>
            </AlertDialog>
        </>
    );
}
