import 'package:flutter/material.dart';

class NavigationControls extends StatelessWidget {
  final bool isNavigationLocked;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onToggleLock;
  final VoidCallback onLocateMe;

  const NavigationControls({
    super.key,
    required this.isNavigationLocked,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onToggleLock,
    required this.onLocateMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: 'zoom_in',
          onPressed: onZoomIn,
          backgroundColor: Theme.of(context).cardColor,
          child: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
        ),
        const SizedBox(height: 8),
        FloatingActionButton.small(
          heroTag: 'zoom_out',
          onPressed: onZoomOut,
          backgroundColor: Theme.of(context).cardColor,
          child: Icon(Icons.remove, color: Theme.of(context).iconTheme.color),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: 'navigation_lock',
              onPressed: onToggleLock,
              backgroundColor: isNavigationLocked
                  ? Colors.blue
                  : Theme.of(context).cardColor,
              child: Icon(
                isNavigationLocked
                    ? Icons.navigation
                    : Icons.navigation_outlined,
                color: isNavigationLocked
                    ? Colors.white
                    : Theme.of(context).iconTheme.color,
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              heroTag: 'locate_me',
              onPressed: onLocateMe,
              backgroundColor: Theme.of(context).cardColor,
              child: Icon(
                Icons.my_location,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
