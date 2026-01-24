import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_theme.dart';

class NavigationCompass extends StatelessWidget {
  final MapController mapController;
  final VoidCallback onResetRotation;

  const NavigationCompass({
    super.key,
    required this.mapController,
    required this.onResetRotation,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MapEvent>(
      stream: mapController.mapEventStream,
      builder: (context, snapshot) {
        final rotation = mapController.camera.rotation;
        
        return AnimatedOpacity(
          opacity: rotation == 0 ? 0.4 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: InkWell(
            onTap: onResetRotation,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: rotation == 0 ? Colors.transparent : AppTheme.primaryPink.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // N/S indicators
                  Transform.rotate(
                    angle: (rotation * (math.pi / 180)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // North indicator
                        Positioned(
                          top: 4,
                          child: Text(
                            'N',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              shadows: [
                                Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 2)
                              ]
                            ),
                          ),
                        ),
                        // South indicator
                        Positioned(
                          bottom: 4,
                          child: Text(
                            'S',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Needle
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 3,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                              ),
                            ),
                            Container(
                              width: 3,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
