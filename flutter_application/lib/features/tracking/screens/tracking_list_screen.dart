// lib/features/tracking/screens/tracking_list_screen.dart
import 'package:flutter/material.dart';

import '../../../core/services/tracking_api.dart';
import '../models/tracking_item.dart';
import '../widgets/tracking_item_tile.dart';

class TrackingListScreen extends StatefulWidget {
  const TrackingListScreen({super.key});

  @override
  State<TrackingListScreen> createState() => _TrackingListScreenState();
}

class _TrackingListScreenState extends State<TrackingListScreen> {
  final TrackingApi _api = TrackingApi();
  final int _userId = 1; // demo user id
  late Future<List<TrackingItem>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = _api.listTrackingItems(_userId);
  }

  void _reload() {
    setState(() {
      _futureItems = _api.listTrackingItems(_userId);
    });
  }

  Future<void> _showAddDialog() async {
    final trackingController = TextEditingController();
    final labelController = TextEditingController();
    String carrier = 'USPS';

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Tracking Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: trackingController,
                  decoration: const InputDecoration(
                    labelText: 'Tracking Number',
                  ),
                ),
                TextField(
                  controller: labelController,
                  decoration: const InputDecoration(
                    labelText: 'Label (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: carrier,
                  items: const [
                    DropdownMenuItem(value: 'USPS', child: Text('USPS')),
                    DropdownMenuItem(value: 'UPS', child: Text('UPS')),
                    DropdownMenuItem(value: 'FEDEX', child: Text('FedEx')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      carrier = value;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Carrier'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) return;

    final trackingNumber = trackingController.text.trim();
    final labelText = labelController.text.trim();
    final label = labelText.isEmpty ? 'Package' : labelText;

    if (trackingNumber.isEmpty) return;

    try {
      await _api.createTrackingItem(
        userId: _userId,
        trackingNumber: trackingNumber,
        carrier: carrier,
        label: label,
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _syncItem(TrackingItem item) async {
    try {
      await _api.syncTrackingItem(item.id);
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tracking Items'),
      ),
      body: FutureBuilder<List<TrackingItem>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text('No tracking items yet.\nTap + to add one.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _reload();
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return TrackingItemTile(
                  item: item,
                  onSync: () => _syncItem(item),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
