import 'dart:convert';
import 'dart:io';

import 'package:mmmmm/features/agencies/domain/entities/agency.dart';
import 'package:mmmmm/features/settings/domain/entities/app_settings.dart';
import 'package:mmmmm/features/transactions/domain/entities/transaction.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BackupService {
  Future<File> createBackupFile({
    required AppSettings settings,
    required List<Agency> agencies,
    required List<Transaction> transactions,
  }) async {
    final payload = {
      'createdAt': DateTime.now().toIso8601String(),
      'settings': _settingsJson(settings),
      'agencies': agencies.map((agency) => agency.toJson()).toList(),
      'transactions': transactions.map((txn) => txn.toJson()).toList(),
    };
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File(p.join(directory.path, fileName));
    await file.writeAsString(jsonEncode(payload), flush: true);
    return file;
  }

  Map<String, dynamic> _settingsJson(AppSettings settings) {
    return {
      'locale': settings.locale.name,
      'currency': settings.currency.name,
      'inventoryMode': settings.inventoryMode.name,
      'isConfigured': settings.isConfigured,
      'driveBackupEnabled': settings.driveBackupEnabled,
      'driveAccountEmail': settings.driveAccountEmail,
      'lastDriveBackup': settings.lastDriveBackup?.toIso8601String(),
    };
  }
}
