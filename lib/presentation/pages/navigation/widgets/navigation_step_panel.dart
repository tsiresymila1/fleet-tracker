import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class NavigationStepPanel extends StatelessWidget {
  final List<LatLng>? route;
  final String destinationText;
  final VoidCallback onStopNavigation;

  const NavigationStepPanel({
    super.key,
    required this.route,
    required this.destinationText,
    required this.onStopNavigation,
  });

  @override
  Widget build(BuildContext context) {
    if (route == null || route!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Theme.of(context).cardColor.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.turn_right,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    Text(
                      'Next Turn',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'map_navigating_to'.tr()} $destinationText',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        '${(route!.length * 0.05).toStringAsFixed(1)} km ${"map_remaining".tr()}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: onStopNavigation,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
