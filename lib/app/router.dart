import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/agencies/presentation/screens/agencies_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/help/presentation/screens/help_center_screen.dart';
import '../features/manual_entry/presentation/screens/manual_entry_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/reports/presentation/screens/reports_screen.dart';
import '../features/scan/presentation/screens/scan_document_screen.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/transactions/presentation/screens/recent_operations_screen.dart';

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
            GoRoute(
              path: '/scan',
              builder: (context, state) => const ScanDocumentScreen(),
            ),
            GoRoute(
              path: '/manual-entry',
              builder: (context, state) => const ManualEntryScreen(),
            ),
            GoRoute(
              path: '/reports',
              builder: (context, state) => const ReportsScreen(),
            ),
            GoRoute(
              path: '/help',
              builder: (context, state) => const HelpCenterScreen(),
            ),
            GoRoute(
              path: '/agencies',
              builder: (context, state) => const AgenciesScreen(),
            ),
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const RecentOperationsScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
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
