import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  getIt.registerSingletonWithDependencies<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<LocalSettingsDataSource>()),
    dependsOn: [LocalSettingsDataSource],
  );

  getIt.registerSingletonWithDependencies<SettingsController>(
    () => SettingsController(getIt<SettingsRepository>()),
    dependsOn: [SettingsRepository],
  );

  await getIt.allReady();
}
