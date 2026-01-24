"use client";

import { useState, useMemo, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { createClient } from '@/utils/supabase/client';
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { DatePicker } from "@/components/ui/date-picker";
import { TrajectoryView } from "@/components/trajectory-view";
import { PurgeDataDialog } from "@/components/purge-data-dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { 
  Filter,
  FileJson,
  CheckCircle2
} from "lucide-react";
import { 
    Search as SearchIcon,
    Map as MapIconLucide,
    Download as DownloadIcon,
    RefreshCw as RefreshIcon,
    Trash2,
} from "lucide-react";
import { toast } from "sonner";
import { 
    DropdownMenu, 
    DropdownMenuContent, 
    DropdownMenuItem, 
    DropdownMenuTrigger 
} from '@/components/ui/dropdown-menu';
import { format, startOfMonth, endOfMonth } from "date-fns";
import { useTranslations } from 'next-intl';

interface HistoryItem {
  id: string;
  device: string;
  time: string;
  location: string;
  speed: string;
  status: string;
  // Raw data for trajectory
  latitude?: number;
  longitude?: number;
  recorded_at?: string;
}

interface HistoryTableProps {
  initialData: HistoryItem[];
  currentPage: number;
  totalPages: number;
  totalCount: number;
}

export function HistoryTable({ initialData, currentPage, totalPages, totalCount }: HistoryTableProps) {
  const router = useRouter();
  const supabase = createClient();
  const t = useTranslations();
  const [historyData, setHistoryData] = useState<HistoryItem[]>(initialData);
  const [searchQuery, setSearchQuery] = useState("");
  const [isRefreshing, setIsRefreshing] = useState(false);
  
  // Set default dates to current month
  const getCurrentMonthStart = () => startOfMonth(new Date());
  const getCurrentMonthEnd = () => endOfMonth(new Date());
  
  const [startDate, setStartDate] = useState<Date | undefined>(getCurrentMonthStart());
  const [endDate, setEndDate] = useState<Date | undefined>(getCurrentMonthEnd());
  const [selectedDevice, setSelectedDevice] = useState<string>("all");
  const [showTrajectory, setShowTrajectory] = useState(false);
  const [showPurgeDialog, setShowPurgeDialog] = useState(false);
  
  // Update historyData when initialData changes (after refresh)
  useEffect(() => {
    setHistoryData(initialData);
  }, [initialData]);

  // Get unique devices from history data
  const availableDevices = useMemo(() => {
    const devices = new Set(historyData.map(item => item.device));
    return Array.from(devices).sort();
  }, [historyData]);

  const handleExport = (type: string) => {
    const filtered = getFilteredData();
    if (filtered.length === 0) {
      toast.error(t('history.no_records'));
      return;
    }

    if (type === 'csv') {
      const headers = ['Device', 'Time', 'Location', 'Speed', 'Status'];
      const rows = filtered.map(item => [
        item.device,
        item.time,
        item.location,
        item.speed,
        item.speed,
        item.status === 'moving' ? t('history.moving') : t('history.stopped')
      ]);
      
      const csvContent = [
        headers.join(','),
        ...rows.map(row => row.map(cell => `"${cell}"`).join(','))
      ].join('\n');

      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
      const link = document.createElement('a');
      const url = URL.createObjectURL(blob);
      link.setAttribute('href', url);
      link.setAttribute('download', `fleet-tracker-export-${format(new Date(), 'yyyy-MM-dd')}.csv`);
      link.style.visibility = 'hidden';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      
      toast.success(`Exported ${filtered.length} records as CSV`);
    } else if (type === 'json') {
      const jsonContent = JSON.stringify(filtered, null, 2);
      const blob = new Blob([jsonContent], { type: 'application/json;charset=utf-8;' });
      const link = document.createElement('a');
      const url = URL.createObjectURL(blob);
      link.setAttribute('href', url);
      link.setAttribute('download', `fleet-tracker-export-${format(new Date(), 'yyyy-MM-dd')}.json`);
      link.style.visibility = 'hidden';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      
      toast.success(`Exported ${filtered.length} records as JSON`);
    }
  };

  const handleRefresh = async () => {
    setIsRefreshing(true);
    try {
      const { data, error } = await supabase
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
        `)
        .order('recorded_at', { ascending: false })
        .limit(100);

      if (error) throw error;

      interface PositionData {
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

      const positions = (data as unknown as PositionData[]) || [];
      const formatted = positions.map((p) => ({
        id: p.id,
        device: p.devices?.device_name || 'Unknown',
        time: new Date(p.recorded_at).toLocaleString(),
        location: `${p.latitude.toFixed(4)}° N, ${p.longitude.toFixed(4)}° E`,
        speed: `${p.speed} km/h`,
        status: p.speed > 0 ? 'moving' : 'stopped',
        latitude: p.latitude,
        longitude: p.longitude,
        recorded_at: p.recorded_at
      }));

      setHistoryData(formatted);
      toast.success(t('history.synchronized'));
    } catch (error) {
      const err = error as Error;
      toast.error(err.message || "Failed to synchronize");
    } finally {
      setIsRefreshing(false);
    }
  };

  const getFilteredData = () => {
    let filtered = historyData.filter(row => {
      // Device filter
      if (selectedDevice !== "all" && row.device !== selectedDevice) {
        return false;
      }
      
      // Search filter
      return row.device.toLowerCase().includes(searchQuery.toLowerCase()) ||
             row.status.toLowerCase().includes(searchQuery.toLowerCase());
    });

    // Filter by date range if dates are selected
    if (startDate || endDate) {
      filtered = filtered.filter(row => {
        if (!row.recorded_at) return false;
        const rowDate = new Date(row.recorded_at);
        if (startDate && rowDate < startDate) return false;
        if (endDate) {
          const endDatePlusOne = new Date(endDate);
          endDatePlusOne.setHours(23, 59, 59, 999);
          if (rowDate > endDatePlusOne) return false;
        }
        return true;
      });
    }

    return filtered;
  };

  const filteredData = getFilteredData();

  const trajectoryPoints = useMemo(() => {
    return filteredData
      .filter(item => item.latitude !== undefined && item.longitude !== undefined && item.recorded_at)
      .map(item => ({
        latitude: item.latitude!,
        longitude: item.longitude!,
        recorded_at: item.recorded_at!,
        speed: parseFloat(item.speed.replace(' km/h', '')) || 0,
        device: item.device
      }))
      .sort((a, b) => new Date(a.recorded_at).getTime() - new Date(b.recorded_at).getTime());
  }, [filteredData]);

  const handleViewTrajectory = () => {
    if (trajectoryPoints.length === 0) {
      toast.error("No trajectory data available for the selected filters");
      return;
    }
    setShowTrajectory(true);
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-end gap-2">
          <Button 
            variant="outline" 
            className="border-input hover:bg-accent hover:text-accent-foreground h-11"
            onClick={handleRefresh}
            disabled={isRefreshing}
          >
            <RefreshIcon className={`mr-2 h-4 w-4 ${isRefreshing ? 'animate-spin' : ''}`} /> {t('history.sync')}
          </Button>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button variant="outline" className="border-input hover:bg-accent hover:text-accent-foreground h-11">
                    <DownloadIcon className="mr-2 h-4 w-4 text-primary" /> {t('history.export')}
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="font-outfit">
                <DropdownMenuItem onClick={() => handleExport('csv')}>
                    <Filter className="mr-2 h-4 w-4" /> {t('history.csv')}
                </DropdownMenuItem>
                <DropdownMenuItem onClick={() => handleExport('json')}>
                    <FileJson className="mr-2 h-4 w-4" /> {t('history.json')}
                </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
          <Button 
            className="bg-primary hover:bg-primary/90 text-white shadow-lg shadow-primary/20"
            onClick={handleViewTrajectory}
            disabled={trajectoryPoints.length === 0}
          >
            <MapIconLucide className="mr-2 h-4 w-4" /> {t('history.trajectory')}
          </Button>
          <Button 
            variant="destructive"
            className=""
            onClick={() => setShowPurgeDialog(true)}
          >
            <Trash2 className="mr-2 h-4 w-4" /> {t('history.purge')}
          </Button>
      </div>

      <Card className="border-border bg-card/50 backdrop-blur-md">
        <CardContent className="p-4">
          <div className="grid gap-4 md:grid-cols-5 items-center">
            <div className="relative">
              <SearchIcon className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground z-10" />
              <Input 
                placeholder={t('history.search')} 
                className="pl-9 focus:ring-primary/20" 
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
            </div>
            <Select value={selectedDevice} onValueChange={setSelectedDevice}>
              <SelectTrigger className="w-full border-primary/20 hover:border-primary/40">
                <SelectValue placeholder={t('common.pleaseSelect')} />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">{t('history.all_devices')}</SelectItem>
                {availableDevices.map((device) => (
                  <SelectItem key={device} value={device}>
                    {device}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <DatePicker
              date={startDate}
              onDateChange={setStartDate}
              placeholder={t('history.start_date')}
            />
            <div className="flex items-center justify-center text-[10px] uppercase font-bold tracking-widest text-muted-foreground">
              {t('history.to_range')}
            </div>
            <DatePicker
              date={endDate}
              onDateChange={setEndDate}
              placeholder={t('history.end_date')}
            />
          </div>
        </CardContent>
      </Card>

      <TrajectoryView
        open={showTrajectory}
        onOpenChange={setShowTrajectory}
        points={trajectoryPoints}
        availableDevices={availableDevices}
        selectedDeviceFilter={selectedDevice}
      />

      <PurgeDataDialog
        open={showPurgeDialog}
        onOpenChange={setShowPurgeDialog}
        availableDevices={availableDevices}
        onPurgeComplete={handleRefresh}
      />

      <div className="rounded-2xl border border-border bg-card/50 backdrop-blur-md overflow-hidden shadow-sm">
        <div className="p-4 border-b border-border bg-muted/30 flex justify-between items-center">
            <p className="text-xs font-bold text-muted-foreground tracking-widest uppercase">{t('history.title')}: {filteredData.length} {t('history.entries')}</p>
        </div>
        <Table>
          <TableHeader>
            <TableRow className="border-border hover:bg-muted/50 bg-muted/20">
              <TableHead className="font-bold uppercase text-[10px]">{t('history.transmission')}</TableHead>
              <TableHead className="font-bold uppercase text-[10px]">{t('history.uplink_time')}</TableHead>
              <TableHead className="font-bold uppercase text-[10px]">{t('history.location')}</TableHead>
              <TableHead className="font-bold uppercase text-[10px]">{t('history.ground_speed')}</TableHead>
              <TableHead className="font-bold uppercase text-[10px]">{t('history.system_status')}</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.map((row) => (
              <TableRow key={row.id} className="border-border hover:bg-muted/50 transition-colors group">
                <TableCell className="font-semibold text-foreground group-hover:text-primary transition-colors">{row.device}</TableCell>
                <TableCell className="text-muted-foreground text-xs">{row.time}</TableCell>
                <TableCell className="text-muted-foreground font-mono text-[10px] tracking-tight">{row.location}</TableCell>
                <TableCell className="text-foreground font-bold">{row.speed}</TableCell>
                <TableCell>
                  <span className={`inline-flex items-center rounded-lg px-2.5 py-1 text-[10px] font-bold uppercase tracking-wider ${
                    row.status === 'stopped' ? 'bg-muted text-muted-foreground' : 
                    'bg-green-500/10 text-green-500 border border-green-500/20'
                  }`}>
                    {row.status === 'moving' && <CheckCircle2 className="w-3 h-3 mr-1.5" />}
                    {row.status === 'moving' ? t('history.moving') : t('history.stopped')}
                  </span>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
        {filteredData.length === 0 && (
            <div className="py-20 text-center space-y-3">
                <SearchIcon className="h-10 w-10 text-muted-foreground mx-auto" />
                <p className="text-muted-foreground font-medium">{t('history.no_records')}</p>
            </div>
        )}
      </div>


      {/* Pagination Controls */}
      <div className="flex items-center justify-between px-2">
        <div className="text-sm text-muted-foreground">
          {t.rich('history.pagination', {
            current: currentPage,
            total: totalPages,
            count: totalCount,
            bold: (chunks) => <span className="font-bold text-foreground">{chunks}</span>
          })}
        </div>
        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => {
              const params = new URLSearchParams(window.location.search);
              params.set('page', (currentPage - 1).toString());
              router.push(`?${params.toString()}`);
            }}
            disabled={currentPage <= 1}
          >
            {t('history.previous')}
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={() => {
              const params = new URLSearchParams(window.location.search);
              params.set('page', (currentPage + 1).toString());
              router.push(`?${params.toString()}`);
            }}
            disabled={currentPage >= totalPages}
          >
            {t('history.next')}
          </Button>
        </div>
      </div>
    </div>
  );
}
