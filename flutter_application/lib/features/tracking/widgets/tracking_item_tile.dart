// lib/features/tracking/widgets/tracking_item_tile.dart
import 'package:flutter/material.dart';

import '../models/tracking_item.dart';

class TrackingItemTile extends StatelessWidget {
  final TrackingItem item;
  final VoidCallback onSync;

  const TrackingItemTile({
    super.key,
    required this.item,
    required this.onSync,
  });

  String _subtitle() {
    final parts = <String>[
      item.trackingNumber,
      item.carrier,
      item.status,
    ];
    return parts.join(' • ');
  }

  String? _eta() {
    if (item.estimatedDelivery == null) return null;
    final date = item.estimatedDelivery!;
    return 'ETA: ${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final eta = _eta();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(item.label),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_subtitle()),
            if (eta != null)
              Text(
                eta,
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.sync),
          onPressed: onSync,
        ),
      ),
    );
  }
}
