import 'package:equatable/equatable.dart';

enum AppLocale {
  ar,
  en,
}

enum InventoryMode {
  simple,
  full,
}

enum CurrencyCode {
  yer,
  sar,
}

class AppSettings extends Equatable {
  const AppSettings({
    required this.locale,
    required this.currency,
    required this.inventoryMode,
    required this.isConfigured,
  });

  final AppLocale locale;
  final CurrencyCode currency;
  final InventoryMode inventoryMode;
  final bool isConfigured;

  AppSettings copyWith({
    AppLocale? locale,
    CurrencyCode? currency,
    InventoryMode? inventoryMode,
    bool? isConfigured,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      currency: currency ?? this.currency,
      inventoryMode: inventoryMode ?? this.inventoryMode,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }

  static AppSettings defaults() {
    return const AppSettings(
      locale: AppLocale.ar,
      currency: CurrencyCode.yer,
      inventoryMode: InventoryMode.full,
      isConfigured: false,
    );
  }

  @override
  List<Object?> get props => [locale, currency, inventoryMode, isConfigured];
}
