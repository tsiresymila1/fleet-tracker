"use client";

import { MapContainer, TileLayer, Polyline, Marker, Popup, useMap } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import { useEffect, useMemo, useState } from "react";
import L from "leaflet";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";

interface TrajectoryPoint {
  latitude: number;
  longitude: number;
  recorded_at: string;
  speed: number;
  device?: string;
}

interface TrajectoryViewProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  points: TrajectoryPoint[];
  availableDevices?: string[];
  selectedDeviceFilter?: string;
}

// Color palette for different devices
const DEVICE_COLORS = [
  "#3b82f6", // blue
  "#10b981", // green
  "#f59e0b", // amber
  "#ef4444", // red
  "#8b5cf6", // purple
  "#ec4899", // pink
  "#06b6d4", // cyan
  "#f97316", // orange
  "#84cc16", // lime
  "#6366f1", // indigo
];

function MapBounds({ points }: { points: TrajectoryPoint[] }) {
  const map = useMap();

  useEffect(() => {
    if (points.length === 0) return;

    const bounds = points.map(p => [p.latitude, p.longitude] as [number, number]);
    map.fitBounds(bounds, { padding: [50, 50], maxZoom: 15 });
  }, [map, points]);

  return null;
}

// Group points by device
function groupPointsByDevice(points: TrajectoryPoint[]): Map<string, TrajectoryPoint[]> {
  const grouped = new Map<string, TrajectoryPoint[]>();
  
  points.forEach(point => {
    const device = point.device || 'Unknown';
    if (!grouped.has(device)) {
      grouped.set(device, []);
    }
    grouped.get(device)!.push(point);
  });
  
  // Sort each device's points by time
  grouped.forEach((devicePoints) => {
    devicePoints.sort((a, b) => new Date(a.recorded_at).getTime() - new Date(b.recorded_at).getTime());
  });
  
  return grouped;
}

export function TrajectoryView({ open, onOpenChange, points, availableDevices = [], selectedDeviceFilter = "all" }: TrajectoryViewProps) {
  const [selectedDevices, setSelectedDevices] = useState<string[]>([]);
  
  useEffect(() => {
    // Fix default icon issues with Next.js
    // @ts-expect-error - Leaflet internal property manipulation
    delete L.Icon.Default.prototype._getIconUrl;
    L.Icon.Default.mergeOptions({
      iconRetinaUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
      iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
      shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
    });
  }, []);

  // Initialize selected devices when dialog opens
  useEffect(() => {
    if (open) {
      if (selectedDeviceFilter === "all") {
        setSelectedDevices(availableDevices.length > 0 ? availableDevices : Array.from(new Set(points.map(p => p.device || 'Unknown'))));
      } else {
        setSelectedDevices([selectedDeviceFilter]);
      }
    }
  }, [open, selectedDeviceFilter, availableDevices, points]);

  // Group points by device
  const groupedPoints = useMemo(() => {
    return groupPointsByDevice(points);
  }, [points]);

  // Filter points based on selected devices
  const filteredPoints = useMemo(() => {
    if (selectedDevices.length === 0) return [];
    const filtered: TrajectoryPoint[] = [];
    selectedDevices.forEach(device => {
      const devicePoints = groupedPoints.get(device) || [];
      filtered.push(...devicePoints);
    });
    return filtered.sort((a, b) => new Date(a.recorded_at).getTime() - new Date(b.recorded_at).getTime());
  }, [selectedDevices, groupedPoints]);

  // Get device color
  const getDeviceColor = (device: string, index: number): string => {
    const deviceIndex = Array.from(groupedPoints.keys()).indexOf(device);
    return DEVICE_COLORS[deviceIndex % DEVICE_COLORS.length];
  };

  if (points.length === 0) {
    return (
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent className="max-w-4xl">
          <DialogHeader>
            <DialogTitle>Device Trajectory</DialogTitle>
            <DialogDescription>
              No trajectory data available for the selected time range.
            </DialogDescription>
          </DialogHeader>
        </DialogContent>
      </Dialog>
    );
  }

  const allDevices = Array.from(groupedPoints.keys());
  const center: [number, number] = filteredPoints.length > 0 
    ? [filteredPoints[Math.floor(filteredPoints.length / 2)].latitude, filteredPoints[Math.floor(filteredPoints.length / 2)].longitude]
    : points.length > 0
    ? [points[Math.floor(points.length / 2)].latitude, points[Math.floor(points.length / 2)].longitude]
    : [0, 0];

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="min-w-6xl h-[80vh] p-0">
        <DialogHeader className="px-6 pt-6">
          <DialogTitle>Device Trajectory</DialogTitle>
          <DialogDescription>
            {filteredPoints.length > 0 && (
              <>
                {filteredPoints.length} points • {new Date(filteredPoints[0].recorded_at).toLocaleString()} to {new Date(filteredPoints[filteredPoints.length - 1].recorded_at).toLocaleString()}
              </>
            )}
          </DialogDescription>
        </DialogHeader>
        <div className="px-6 pb-4 space-y-3 border-b border-border">
          <div className="flex items-center gap-4 flex-wrap">
            <Label className="text-sm font-semibold whitespace-nowrap">Show Devices:</Label>
            <div className="flex items-center gap-2">
              <Button
                variant={selectedDevices.length === allDevices.length ? "default" : "outline"}
                size="sm"
                onClick={() => setSelectedDevices(allDevices)}
                className="h-8 text-xs"
              >
                All ({allDevices.length})
              </Button>
              {allDevices.map((device) => {
                const isSelected = selectedDevices.includes(device);
                return (
                  <Button
                    key={device}
                    variant={isSelected ? "default" : "outline"}
                    size="sm"
                    onClick={() => {
                      if (isSelected) {
                        setSelectedDevices(selectedDevices.filter(d => d !== device));
                      } else {
                        setSelectedDevices([...selectedDevices, device]);
                      }
                    }}
                    className="h-8 text-xs flex items-center gap-1.5"
                    style={isSelected ? { 
                      backgroundColor: getDeviceColor(device, 0),
                      borderColor: getDeviceColor(device, 0),
                      color: 'white'
                    } : {}}
                  >
                    <div 
                      className="w-2 h-2 rounded-full" 
                      style={{ backgroundColor: isSelected ? 'white' : getDeviceColor(device, 0) }}
                    />
                    {device} ({(groupedPoints.get(device) || []).length})
                  </Button>
                );
              })}
            </div>
          </div>
        </div>
        <div className="flex-1 relative px-6 pb-6">
          <MapContainer 
            center={center} 
            zoom={13} 
            scrollWheelZoom={true} 
            className="h-full w-full rounded-lg"
            style={{ minHeight: '500px' }}
          >
            <TileLayer
              attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />
            
            <MapBounds points={filteredPoints.length > 0 ? filteredPoints : points} />
            
            {/* Render polylines for each selected device */}
            {selectedDevices.map((device, deviceIndex) => {
              const devicePoints = groupedPoints.get(device) || [];
              if (devicePoints.length < 2) return null;
              
              const polylinePositions = devicePoints.map(p => [p.latitude, p.longitude] as [number, number]);
              const color = getDeviceColor(device, deviceIndex);
              const startPoint = devicePoints[0];
              const endPoint = devicePoints[devicePoints.length - 1];
              
              // Custom icons for start/end
              const startIcon = new L.Icon({
                iconUrl: `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='${encodeURIComponent(color)}'%3E%3Ccircle cx='12' cy='12' r='10'/%3E%3C/svg%3E`,
                iconSize: [20, 20],
                iconAnchor: [10, 10],
              });

              const endIcon = new L.Icon({
                iconUrl: `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23ef4444'%3E%3Ccircle cx='12' cy='12' r='10'/%3E%3C/svg%3E`,
                iconSize: [20, 20],
                iconAnchor: [10, 10],
              });
              
              return (
                <div key={device}>
                  <Polyline
                    positions={polylinePositions}
                    color={color}
                    weight={4}
                    opacity={0.8}
                  />
                  {startPoint && (
                    <Marker position={[startPoint.latitude, startPoint.longitude]} icon={startIcon}>
                      <Popup>
                        <div className="text-zinc-900">
                          <h3 className="font-bold">{device} - Start</h3>
                          <p className="text-xs">{new Date(startPoint.recorded_at).toLocaleString()}</p>
                          <p className="text-xs">Speed: {startPoint.speed} km/h</p>
                        </div>
                      </Popup>
                    </Marker>
                  )}
                  {endPoint && endPoint !== startPoint && (
                    <Marker position={[endPoint.latitude, endPoint.longitude]} icon={endIcon}>
                      <Popup>
                        <div className="text-zinc-900">
                          <h3 className="font-bold">{device} - End</h3>
                          <p className="text-xs">{new Date(endPoint.recorded_at).toLocaleString()}</p>
                          <p className="text-xs">Speed: {endPoint.speed} km/h</p>
                        </div>
                      </Popup>
                    </Marker>
                  )}
                </div>
              );
            })}
          </MapContainer>
          <style jsx global>{`
            .leaflet-layer,
            .leaflet-control-zoom-in,
            .leaflet-control-zoom-out,
            .leaflet-control-attribution {
              filter: invert(100%) hue-rotate(180deg) brightness(95%) contrast(90%);
            }
            .leaflet-container {
              background-color: #09090b !important;
            }
          `}</style>
        </div>
      </DialogContent>
    </Dialog>
  );
}
