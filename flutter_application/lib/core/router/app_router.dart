import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/tracking/screens/tracking_list_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/tracking', // your existing start page
    routes: [
      // Added tracking route
      GoRoute(
        path: '/tracking',
        builder: (context, state) => const TrackingListScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Text(state.error?.toString() ?? 'Unknown error'),
      ),
    ),
  );
});
