"use client";

import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import { ShieldCheck, Copy, Trash2, Plus, Globe } from "lucide-react";
import { toast } from "sonner";
import { createClient } from "@/utils/supabase/client";
import { useTranslations } from "next-intl";
import { MapContainer, TileLayer, Marker, Popup, useMap } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";

interface ApiToken {
  id: string;
  name: string;
  token: string;
  scope: string;
  created_at: string;
  last_used_at: string | null;
}

interface DeviceLocation {
  device_name: string;
  latitude: number;
  longitude: number;
  last_seen_at: string | null;
}

export function IntegrationRelay() {
  const [tokens, setTokens] = useState<ApiToken[]>([]);
  const [showTokenDialog, setShowTokenDialog] = useState(false);
  const [newTokenName, setNewTokenName] = useState("");
  const [newTokenScope, setNewTokenScope] = useState("read");
  const [deviceLocations, setDeviceLocations] = useState<DeviceLocation[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const supabase = createClient();

  const t = useTranslations();
  const loadTokens = useCallback(async () => {
    try {
      const response = await fetch('/api/tokens');
      if (!response.ok) {
        throw new Error('Failed to load tokens');
      }
      const result = await response.json();
      setTokens(result.data || []);
    } catch (error) {
      console.error("Error loading tokens:", error);
    }
  }, []);

  const loadDeviceLocations = useCallback(async () => {
    try {
      setIsLoading(true);
      const { data, error } = await supabase
        .from('devices')
        .select(`
          device_name,
          last_seen_at,
          positions (
            latitude,
            longitude,
            recorded_at
          )
        `)
        .eq('is_enabled', true);

      if (error) throw error;

      interface DevicePosition {
        latitude: number;
        longitude: number;
        recorded_at: string;
      }
      
      interface DeviceData {
        device_name: string;
        last_seen_at: string | null;
        positions: DevicePosition[];
      }

      const locations: DeviceLocation[] = [];
      if (data) {
        const devices = data as unknown as DeviceData[];
        for (const device of devices) {
          const positions = device.positions;
          if (positions && positions.length > 0) {
            const latestPos = positions[0];
            locations.push({
              device_name: device.device_name,
              latitude: latestPos.latitude,
              longitude: latestPos.longitude,
              last_seen_at: device.last_seen_at
            });
          }
        }
      }
      setDeviceLocations(locations);
    } catch (error) {
      console.error("Error loading device locations:", error);
    } finally {
      setIsLoading(false);
    }
  }, [supabase]);

  useEffect(() => {
    loadTokens();
    loadDeviceLocations();
  }, [loadTokens, loadDeviceLocations]);

  const createToken = async () => {
    if (!newTokenName.trim()) {
      toast.error("Please enter a token name");
      return;
    }

    try {
      const response = await fetch('/api/tokens', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: newTokenName,
          scope: newTokenScope,
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to create token');
      }

      const result = await response.json();
      const newToken = result.data;

      setTokens([...tokens, newToken]);
      
      toast.success("API token created successfully!");
      setShowTokenDialog(false);
      setNewTokenName("");
      setNewTokenScope("read");
      
      // Reload tokens to get fresh data
      loadTokens();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Failed to create token");
      console.error(error);
    }
  };

  const copyToken = (token: string) => {
    navigator.clipboard.writeText(token);
    toast.success("Token copied to clipboard");
  };

  const deleteToken = async (tokenId: string) => {
    try {
      const response = await fetch(`/api/tokens/${tokenId}`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        throw new Error('Failed to delete token');
      }

      const updatedTokens = tokens.filter(t => t.id !== tokenId);
      setTokens(updatedTokens);
      toast.success("Token deleted");
    } catch (error) {
      toast.error("Failed to delete token");
      console.error(error);
    }
  };

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

  const getMapCenter = (): [number, number] => {
    if (deviceLocations.length === 0) return [0, 0];
    const avgLat = deviceLocations.reduce((sum, d) => sum + d.latitude, 0) / deviceLocations.length;
    const avgLng = deviceLocations.reduce((sum, d) => sum + d.longitude, 0) / deviceLocations.length;
    return [avgLat, avgLng];
  };

  function MapBounds({ locations }: { locations: DeviceLocation[] }) {
    const map = useMap();
    
    useEffect(() => {
      if (locations.length === 0) return;
      const bounds = locations.map(d => [d.latitude, d.longitude] as [number, number]);
      if (bounds.length > 0) {
        map.fitBounds(bounds, { padding: [20, 20], maxZoom: 10 });
      }
    }, [map, locations]);
    
    return null;
  }

  return (
    <div className="space-y-6">
      {/* API Token Management */}
      <div className="rounded-xl border border-primary/20 bg-primary/5 p-6 relative overflow-hidden">
        <div className="absolute -right-4 -bottom-4 w-24 h-24 bg-primary/10 blur-2xl rounded-full" />
        <div className="relative">
          <h3 className="text-sm font-bold text-primary mb-2 flex items-center gap-2">
            <ShieldCheck className="h-4 w-4" /> {t('integration.secureApiGateway')}
          </h3>
          <p className="text-xs text-muted-foreground leading-relaxed mb-4">
            {t('integration.gatewayDescription')}
          </p>
          
          <div className="space-y-3 mb-4">
            {tokens.length === 0 ? (
              <p className="text-xs text-muted-foreground italic">{t('integration.noTokens')}</p>
            ) : (
              tokens.map((token) => (
                <div key={token.id} className="flex items-center justify-between p-3 bg-background rounded-lg border border-border">
                  <div className="flex-1">
                    <p className="text-sm font-semibold">{token.name}</p>
                    <div className="flex items-center gap-2 mt-1">
                      <code className="text-xs bg-muted px-2 py-1 rounded font-mono">
                        {token.token.substring(0, 12)}...
                      </code>
                      <span className="text-[10px] text-muted-foreground uppercase">
                        {token.scope}
                      </span>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => copyToken(token.token)}
                      className="h-8 w-8 p-0"
                    >
                      <Copy className="h-3 w-3" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => deleteToken(token.id)}
                      className="h-8 w-8 p-0 text-destructive"
                    >
                      <Trash2 className="h-3 w-3" />
                    </Button>
                  </div>
                </div>
              ))
            )}
          </div>

          <Button 
            className="w-full bg-primary hover:bg-primary/90 text-xs h-9 text-white"
            onClick={() => setShowTokenDialog(true)}
          >
            <Plus className="mr-2 h-3 w-3" /> {t('integration.createToken')}
          </Button>
        </div>
      </div>

      {/* Fleet Distribution Map */}
      <div className="space-y-4">
        <h4 className="text-[10px] font-bold text-muted-foreground uppercase tracking-widest">{t('integration.fleetDistribution')}</h4>
        <div className="h-[200px] w-full bg-muted rounded-xl border border-border overflow-hidden">
          {isLoading ? (
            <div className="h-full flex items-center justify-center">
              <div className="text-center space-y-2">
                <Globe className="h-8 w-8 text-muted-foreground mx-auto animate-pulse" />
                <p className="text-[10px] text-muted-foreground italic">{t('integration.loadingMap')}</p>
              </div>
            </div>
          ) : deviceLocations.length === 0 ? (
            <div className="h-full flex items-center justify-center">
              <div className="text-center space-y-2">
                <Globe className="h-8 w-8 text-muted-foreground mx-auto" />
                <p className="text-[10px] text-muted-foreground italic">{t('integration.noActiveDevices')}</p>
              </div>
            </div>
          ) : (
            <MapContainer 
              center={getMapCenter()} 
              zoom={2} 
              scrollWheelZoom={false}
              className="h-full w-full"
            >
              <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
              />
              <MapBounds locations={deviceLocations} />
              {deviceLocations.map((device, idx) => (
                <Marker key={idx} position={[device.latitude, device.longitude]}>
                  <Popup>
                    <div className="text-zinc-900">
                      <h3 className="font-bold">{device.device_name}</h3>
                      <p className="text-xs">
                        {device.last_seen_at 
                          ? `Last seen: ${new Date(device.last_seen_at).toLocaleString()}`
                          : 'Never seen'
                        }
                      </p>
                    </div>
                  </Popup>
                </Marker>
              ))}
            </MapContainer>
          )}
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
      </div>

      {/* Create Token Dialog */}
      <Dialog open={showTokenDialog} onOpenChange={setShowTokenDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('integration.createTokenTitle')}</DialogTitle>
            <DialogDescription>
              {t('integration.createTokenDesc')}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="token-name">{t('integration.tokenName')}</Label>
              <Input
                id="token-name"
                placeholder="e.g., Production API, Development"
                value={newTokenName}
                onChange={(e) => setNewTokenName(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="token-scope">{t('integration.scope')}</Label>
              <select
                id="token-scope"
                className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                value={newTokenScope}
                onChange={(e) => setNewTokenScope(e.target.value)}
              >
                <option value="read">Read Only</option>
                <option value="read-write">Read & Write</option>
                <option value="admin">Admin</option>
              </select>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setShowTokenDialog(false)}>
              {t('integration.cancel')}
            </Button>
            <Button onClick={createToken}>
              {t('integration.create')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
