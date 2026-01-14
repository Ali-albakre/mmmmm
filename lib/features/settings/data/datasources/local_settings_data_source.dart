import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';

class LocalSettingsDataSource {
  LocalSettingsDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _keyConfigured = 'settings.configured';
  static const _keyLocale = 'settings.locale';
  static const _keyCurrency = 'settings.currency';
  static const _keyInventoryMode = 'settings.inventoryMode';

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
    );
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setBool(_keyConfigured, settings.isConfigured);
    await _prefs.setString(_keyLocale, settings.locale.name);
    await _prefs.setString(_keyCurrency, settings.currency.name);
    await _prefs.setString(_keyInventoryMode, settings.inventoryMode.name);
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
}
