// lib/core/services/tracking_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features/tracking/models/tracking_item.dart';

class TrackingApi {
  /// Android emulator → use host machine's localhost via 10.0.2.2
  //static const String baseUrl = 'http://10.0.2.2:8000';
  // If you run Flutter Web/Desktop on same machine, use:
  static const String baseUrl = 'http://localhost:8000';

  final http.Client _client;

  TrackingApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<TrackingItem>> listTrackingItems(int userId) async {
    final uri = Uri.parse('$baseUrl/tracking').replace(queryParameters: {
      'user_id': userId.toString(),
    });

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load tracking items (code ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => TrackingItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<TrackingItem> createTrackingItem({
    required int userId,
    required String trackingNumber,
    required String carrier,
    required String label,
  }) async {
    final uri = Uri.parse('$baseUrl/tracking');

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'tracking_number': trackingNumber,
        'carrier': carrier, // "USPS" | "UPS" | "FEDEX"
        'label': label,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to create tracking item (code ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return TrackingItem.fromJson(data);
  }

  Future<TrackingItem> syncTrackingItem(int itemId) async {
    final uri = Uri.parse('$baseUrl/tracking/$itemId/sync');

    final response = await _client.post(uri);
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to sync tracking item (code ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return TrackingItem.fromJson(data);
  }
}
