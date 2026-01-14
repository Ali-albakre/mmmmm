import '../entities/app_settings.dart';

abstract class SettingsRepository {
  AppSettings? current();
  Stream<AppSettings> watch();
  Future<AppSettings?> load();
  Future<void> save(AppSettings settings);
}
