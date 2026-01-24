import 'package:flutter/material.dart';

class NavigationSideButtons extends StatelessWidget {
  final VoidCallback onSettingsPressed;
  final VoidCallback onHistoryPressed;

  const NavigationSideButtons({
    super.key,
    required this.onSettingsPressed,
    required this.onHistoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Settings Button
        InkWell(
          onTap: onSettingsPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // History Button
        InkWell(
          onTap: onHistoryPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              Icons.history,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ],
    );
  }
}
