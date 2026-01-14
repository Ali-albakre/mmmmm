import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';

class AppRouter {
  AppRouter(SettingsController settingsController)
      : router = GoRouter(
          initialLocation: '/dashboard',
          refreshListenable: settingsController,
          redirect: (context, state) {
            final isConfigured = settingsController.isConfigured;
            final isOnboarding = state.matchedLocation == '/onboarding';

            if (!isConfigured && !isOnboarding) {
              return '/onboarding';
            }

            if (isConfigured && isOnboarding) {
              return '/dashboard';
            }

            return null;
          },
          routes: [
            GoRoute(
              path: '/onboarding',
              builder: (context, state) => const OnboardingScreen(),
            ),
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
          errorBuilder: (context, state) => Scaffold(
            body: Center(
              child: Text(state.error?.toString() ?? 'Route error'),
            ),
          ),
        );

  final GoRouter router;
}
