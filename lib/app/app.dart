import 'package:flutter/material.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

import '../features/settings/presentation/controllers/settings_controller.dart';
import 'router.dart';
import 'theme.dart';

class App extends StatelessWidget {
  App({super.key, required SettingsController settingsController})
      : _settingsController = settingsController,
        _router = AppRouter(settingsController);

  final SettingsController _settingsController;
  final AppRouter _router;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settingsController,
      builder: (context, _) {
        return MaterialApp.router(
          onGenerateTitle: (context) =>
              AppLocalizations.of(context)?.appTitle ?? 'PharmaLedger',
          locale: _settingsController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.light(),
          routerConfig: _router.router,
        );
      },
    );
  }
}
