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
    required this.driveBackupEnabled,
    required this.driveAccountEmail,
    required this.lastDriveBackup,
    required this.useCloudOcr,
  });

  final AppLocale locale;
  final CurrencyCode currency;
  final InventoryMode inventoryMode;
  final bool isConfigured;
  final bool driveBackupEnabled;
  final String? driveAccountEmail;
  final DateTime? lastDriveBackup;
  final bool useCloudOcr;

  AppSettings copyWith({
    AppLocale? locale,
    CurrencyCode? currency,
    InventoryMode? inventoryMode,
    bool? isConfigured,
    bool? driveBackupEnabled,
    String? driveAccountEmail,
    DateTime? lastDriveBackup,
    bool? useCloudOcr,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      currency: currency ?? this.currency,
      inventoryMode: inventoryMode ?? this.inventoryMode,
      isConfigured: isConfigured ?? this.isConfigured,
      driveBackupEnabled: driveBackupEnabled ?? this.driveBackupEnabled,
      driveAccountEmail: driveAccountEmail ?? this.driveAccountEmail,
      lastDriveBackup: lastDriveBackup ?? this.lastDriveBackup,
      useCloudOcr: useCloudOcr ?? this.useCloudOcr,
    );
  }

  static AppSettings defaults() {
    return const AppSettings(
      locale: AppLocale.ar,
      currency: CurrencyCode.yer,
      inventoryMode: InventoryMode.full,
      isConfigured: false,
      driveBackupEnabled: false,
      driveAccountEmail: null,
      lastDriveBackup: null,
      useCloudOcr: true,
    );
  }

  @override
  List<Object?> get props => [
        locale,
        currency,
        inventoryMode,
        isConfigured,
        driveBackupEnabled,
        driveAccountEmail,
        lastDriveBackup,
        useCloudOcr,
      ];
}
