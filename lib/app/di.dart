import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/agencies/data/datasources/local_agencies_data_source.dart';
import '../features/agencies/data/repositories/agencies_repository_impl.dart';
import '../features/agencies/domain/repositories/agencies_repository.dart';
import '../features/agencies/presentation/controllers/agencies_controller.dart';
import '../features/backup/data/backup_service.dart';
import '../features/backup/data/google_drive_service.dart';
import '../features/backup/presentation/controllers/backup_controller.dart';
import '../features/transactions/data/datasources/local_transactions_data_source.dart';
import '../features/transactions/data/repositories/transactions_repository_impl.dart';
import '../features/transactions/domain/repositories/transactions_repository.dart';
import '../features/transactions/presentation/controllers/transactions_controller.dart';
import '../features/settings/data/datasources/local_settings_data_source.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingleton<Logger>(Logger());

  getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  getIt.registerSingletonWithDependencies<LocalSettingsDataSource>(
    () => LocalSettingsDataSource(getIt<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );
  getIt.registerSingletonWithDependencies<LocalAgenciesDataSource>(
    () => LocalAgenciesDataSource(getIt<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );
  getIt.registerSingletonWithDependencies<LocalTransactionsDataSource>(
    () => LocalTransactionsDataSource(getIt<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );

  getIt.registerSingletonWithDependencies<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<LocalSettingsDataSource>()),
    dependsOn: [LocalSettingsDataSource],
  );
  getIt.registerSingletonWithDependencies<AgenciesRepository>(
    () => AgenciesRepositoryImpl(getIt<LocalAgenciesDataSource>()),
    dependsOn: [LocalAgenciesDataSource],
  );
  getIt.registerSingletonWithDependencies<TransactionsRepository>(
    () => TransactionsRepositoryImpl(getIt<LocalTransactionsDataSource>()),
    dependsOn: [LocalTransactionsDataSource],
  );

  getIt.registerSingletonWithDependencies<SettingsController>(
    () => SettingsController(getIt<SettingsRepository>()),
    dependsOn: [SettingsRepository],
  );
  getIt.registerSingletonWithDependencies<AgenciesController>(
    () => AgenciesController(getIt<AgenciesRepository>()),
    dependsOn: [AgenciesRepository],
  );
  getIt.registerSingletonWithDependencies<TransactionsController>(
    () => TransactionsController(getIt<TransactionsRepository>()),
    dependsOn: [TransactionsRepository],
  );
  getIt.registerSingleton<BackupService>(BackupService());
  getIt.registerSingleton<GoogleDriveService>(GoogleDriveService());
  getIt.registerSingletonWithDependencies<BackupController>(
    () => BackupController(
      getIt<SettingsController>(),
      getIt<AgenciesRepository>(),
      getIt<TransactionsRepository>(),
      getIt<BackupService>(),
      getIt<GoogleDriveService>(),
    ),
    dependsOn: [
      SettingsController,
      AgenciesRepository,
      TransactionsRepository,
    ],
  );

  await getIt.allReady();
}
