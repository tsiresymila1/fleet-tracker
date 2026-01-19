import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

extension AnimatedMapController on MapController {
  void animateTo({
    required LatLng dest,
    double? zoom,
    double? rotation,
    Curve curve = Curves.easeInOut,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    final camera = this.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: dest.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: dest.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: zoom ?? camera.zoom);
    final rotateTween = Tween<double>(begin: camera.rotation, end: rotation ?? camera.rotation);

    final controller = AnimationController(vsync: VerticalSyncProvider(), duration: duration);
    final animation = CurvedAnimation(parent: controller, curve: curve);

    controller.addListener(() {
      moveAndRotate(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        rotateTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}

class VerticalSyncProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
