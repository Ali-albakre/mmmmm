import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';

class LocalSettingsDataSource {
  LocalSettingsDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _keyConfigured = 'settings.configured';
  static const _keyLocale = 'settings.locale';
  static const _keyCurrency = 'settings.currency';
  static const _keyInventoryMode = 'settings.inventoryMode';
  static const _keyUseCloudOcr = 'settings.useCloudOcr';
  static const _keyDriveBackupEnabled = 'settings.driveBackupEnabled';
  static const _keyDriveAccountEmail = 'settings.driveAccountEmail';
  static const _keyLastDriveBackup = 'settings.lastDriveBackup';

  AppSettings? read() {
    final isConfigured = _prefs.getBool(_keyConfigured) ?? false;
    if (!isConfigured) {
      return null;
    }

    return AppSettings(
      locale: _readEnum(_prefs.getString(_keyLocale), AppLocale.values, AppLocale.ar),
      currency: _readEnum(
        _prefs.getString(_keyCurrency),
        CurrencyCode.values,
        CurrencyCode.yer,
      ),
      inventoryMode: _readEnum(
        _prefs.getString(_keyInventoryMode),
        InventoryMode.values,
        InventoryMode.full,
      ),
      isConfigured: true,
      driveBackupEnabled: _prefs.getBool(_keyDriveBackupEnabled) ?? false,
      driveAccountEmail: _prefs.getString(_keyDriveAccountEmail),
      lastDriveBackup: _readDateTime(_prefs.getString(_keyLastDriveBackup)),
      useCloudOcr: _prefs.getBool(_keyUseCloudOcr) ?? false,
    );
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setBool(_keyConfigured, settings.isConfigured);
    await _prefs.setString(_keyLocale, settings.locale.name);
    await _prefs.setString(_keyCurrency, settings.currency.name);
    await _prefs.setString(_keyInventoryMode, settings.inventoryMode.name);
    await _prefs.setBool(_keyUseCloudOcr, settings.useCloudOcr);
    await _prefs.setBool(_keyDriveBackupEnabled, settings.driveBackupEnabled);
    if (settings.driveAccountEmail != null) {
      await _prefs.setString(_keyDriveAccountEmail, settings.driveAccountEmail!);
    } else {
      await _prefs.remove(_keyDriveAccountEmail);
    }
    if (settings.lastDriveBackup != null) {
      await _prefs.setString(
        _keyLastDriveBackup,
        settings.lastDriveBackup!.toIso8601String(),
      );
    } else {
      await _prefs.remove(_keyLastDriveBackup);
    }
  }

  T _readEnum<T extends Enum>(String? value, List<T> values, T fallback) {
    if (value == null) {
      return fallback;
    }
    for (final item in values) {
      if (item.name == value) {
        return item;
      }
    }
    return fallback;
  }

  DateTime? _readDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}
