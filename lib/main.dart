import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'app/di.dart';
import 'features/agencies/presentation/controllers/agencies_controller.dart';
import 'features/backup/presentation/controllers/backup_controller.dart';
import 'features/settings/presentation/controllers/settings_controller.dart';
import 'features/transactions/presentation/controllers/transactions_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Allow running without a bundled .env file.
  }
  await configureDependencies();
  final settingsController = getIt<SettingsController>();
  await settingsController.load();
  final agenciesController = getIt<AgenciesController>();
  await agenciesController.load();
  final transactionsController = getIt<TransactionsController>();
  await transactionsController.load();
  final backupController = getIt<BackupController>();
  await backupController.maybeBackupDaily();
  runApp(App(settingsController: settingsController));
}

