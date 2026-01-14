import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di.dart';
import 'features/settings/presentation/controllers/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final settingsController = getIt<SettingsController>();
  await settingsController.load();
  runApp(App(settingsController: settingsController));
}
