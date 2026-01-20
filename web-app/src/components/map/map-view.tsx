"use client";

import dynamic from "next/dynamic";
import { forwardRef } from "react";

interface Marker {
  id: string;
  name: string;
  lat: number;
  lng: number;
  status: string;
}

interface MapViewProps {
  markers: Marker[];
  center?: [number, number];
}

const Map = dynamic(() => import("./inner-map"), {
  ssr: false,
  loading: () => <div className="h-full w-full bg-zinc-900 animate-pulse" />,
});

const MapView = forwardRef<{ centerMap: (lat: number, lng: number) => void }, MapViewProps>(
  (props, ref) => {
    return <Map {...props} ref={ref} />;
  }
);

MapView.displayName = "MapView";

export default MapView;
