"use client";

import { MapContainer, TileLayer, Marker, Popup, useMap } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import { useEffect, useState, forwardRef, useImperativeHandle } from "react";
import L from "leaflet";
import { Navigation } from "lucide-react";

interface MarkerData {
  id: string;
  name: string;
  lat: number;
  lng: number;
  status: string;
}

interface InnerMapProps {
  center?: [number, number];
  zoom?: number;
  markers?: MarkerData[];
}

function LocationButton({ userLocation }: { userLocation: [number, number] | null }) {
  const map = useMap();

  const handleLocate = () => {
    if (userLocation) {
      map.flyTo(userLocation, 15, { duration: 1 });
    }
  };

  if (!userLocation) return null;

  return (
    <button
      onClick={handleLocate}
      className="absolute bottom-6 right-6 z-[1000] bg-primary hover:bg-primary/90 text-white p-3 rounded-full shadow-lg transition-all"
      title="Center on my location"
    >
      <Navigation className="h-5 w-5" />
    </button>
  );
}

function MapController({ onMapReady }: { onMapReady: (map: L.Map) => void }) {
  const map = useMap();
  
  useEffect(() => {
    onMapReady(map);
    
    // Handle window resize to update map size
    const handleResize = () => {
      map.invalidateSize();
    };
    
    window.addEventListener('resize', handleResize);
    
    return () => {
      window.removeEventListener('resize', handleResize);
    };
  }, [map, onMapReady]);

  return null;
}

const InnerMap = forwardRef<{ centerMap: (lat: number, lng: number) => void }, InnerMapProps>(
  ({ 
    center = [48.8566, 2.3522], 
    zoom = 13, 
    markers = [] 
  }, ref) => {
    const [userLocation, setUserLocation] = useState<[number, number] | null>(null);
    const [mapCenter, setMapCenter] = useState<[number, number]>(center);
    const [mapInstance, setMapInstance] = useState<L.Map | null>(null);

    useEffect(() => {
      // Fix default icon issues with Next.js
      // @ts-expect-error - Leaflet internal property manipulation
      delete L.Icon.Default.prototype._getIconUrl;
      L.Icon.Default.mergeOptions({
        iconRetinaUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
        iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
        shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
      });

      // Get user's current location
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            const coords: [number, number] = [
              position.coords.latitude,
              position.coords.longitude,
            ];
            setUserLocation(coords);
            setMapCenter(coords);
            // Center map on user location once obtained
            if (mapInstance) {
              mapInstance.flyTo(coords, 15, { duration: 1 });
            }
          },
          (error) => {
            console.log("Geolocation error:", error.message);
          }
        );
      }
    }, [mapInstance]);

    useImperativeHandle(ref, () => ({
      centerMap: (lat: number, lng: number) => {
        if (mapInstance) {
          mapInstance.flyTo([lat, lng], 15, { duration: 1 });
        }
      }
    }));

    const handleMapReady = (map: L.Map) => {
      setMapInstance(map);
    };

    // Custom icon for user location
    const userIcon = new L.Icon({
      iconUrl: "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%234f46e5'%3E%3Ccircle cx='12' cy='12' r='8'/%3E%3C/svg%3E",
      iconSize: [24, 24],
      iconAnchor: [12, 12],
    });

    return (
      <>
        <MapContainer 
          center={mapCenter} 
          zoom={zoom} 
          scrollWheelZoom={true} 
          className="h-full w-full bg-zinc-950"
          style={{ zIndex: 0, minHeight: '600px' }}
        >
          <MapController onMapReady={handleMapReady} />
          <TileLayer
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          />
          
          {/* User location marker */}
          {userLocation && (
            <Marker position={userLocation} icon={userIcon}>
              <Popup>
                <div className="text-zinc-900">
                  <h3 className="font-bold">Your Location</h3>
                </div>
              </Popup>
            </Marker>
          )}

          {/* Device markers */}
          {markers.map(marker => (
            <Marker key={marker.id} position={[marker.lat, marker.lng]}>
              <Popup>
                <div className="text-zinc-900">
                  <h3 className="font-bold">{marker.name}</h3>
                  <p className="text-xs">{marker.status}</p>
                </div>
              </Popup>
            </Marker>
          ))}

          <LocationButton userLocation={userLocation} />
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
            z-index: 0 !important;
          }
          .leaflet-pane {
            z-index: 0 !important;
          }
        `}</style>
      </>
    );
  }
);

InnerMap.displayName = "InnerMap";

export default InnerMap;
