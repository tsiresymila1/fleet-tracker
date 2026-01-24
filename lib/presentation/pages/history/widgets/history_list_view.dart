import 'package:flutter/material.dart';
import '../../../../data/models/api_responses.dart';

class HistoryListView extends StatelessWidget {
  final List<PositionData> positions;

  const HistoryListView({
    super.key,
    required this.positions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final pos = positions[index];
        final time = DateTime.tryParse(pos.recordedAt);
        final timeStr = time != null
            ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            : pos.recordedAt;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: pos.status == 'moving'
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              child: Icon(
                pos.status == 'moving' ? Icons.directions_car : Icons.pause,
                color: pos.status == 'moving' ? Colors.green : Colors.orange,
              ),
            ),
            title: Text(
              '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              '${pos.status ?? 'unknown'} • ${(pos.speed ?? 0 * 3.6).toStringAsFixed(1)} km/h',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              timeStr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
