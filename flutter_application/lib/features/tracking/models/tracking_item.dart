// lib/features/tracking/models/tracking_item.dart

class TrackingItem {
  final int id;
  final int userId;
  final String trackingNumber;
  final String carrier;
  final String label;
  final String status;
  final DateTime createdAt;
  final DateTime? lastSyncedAt;
  final DateTime? estimatedDelivery;

  TrackingItem({
    required this.id,
    required this.userId,
    required this.trackingNumber,
    required this.carrier,
    required this.label,
    required this.status,
    required this.createdAt,
    this.lastSyncedAt,
    this.estimatedDelivery,
  });

  factory TrackingItem.fromJson(Map<String, dynamic> json) {
    return TrackingItem(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      trackingNumber: json['tracking_number'] as String,
      carrier: json['carrier'] as String,
      label: json['label'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'] as String)
          : null,
    );
  }
}
