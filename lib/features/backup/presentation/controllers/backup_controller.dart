import 'package:flutter/material.dart';
import 'package:mmmmm/features/agencies/domain/repositories/agencies_repository.dart';
import 'package:mmmmm/features/backup/data/backup_service.dart';
import 'package:mmmmm/features/backup/data/google_drive_service.dart';
import 'package:mmmmm/features/settings/domain/entities/app_settings.dart';
import 'package:mmmmm/features/settings/presentation/controllers/settings_controller.dart';
import 'package:mmmmm/features/transactions/domain/repositories/transactions_repository.dart';

class BackupController extends ChangeNotifier {
  BackupController(
    this._settingsController,
    this._agenciesRepository,
    this._transactionsRepository,
    this._backupService,
    this._driveService,
  ) {
    _settingsController.addListener(_onSettingsChanged);
  }

  final SettingsController _settingsController;
  final AgenciesRepository _agenciesRepository;
  final TransactionsRepository _transactionsRepository;
  final BackupService _backupService;
  final GoogleDriveService _driveService;

  bool _isBackingUp = false;
  String? _lastError;

  bool get isBackingUp => _isBackingUp;
  String? get lastError => _lastError;
  AppSettings get settings => _settingsController.settings;

  void _onSettingsChanged() {
    notifyListeners();
  }

  Future<void> enableDriveBackup(bool enabled) async {
    if (enabled) {
      final account = await _driveService.signIn();
      if (account == null) {
        _lastError = 'Google Drive sign-in cancelled.';
        notifyListeners();
        return;
      }
      await _settingsController.save(
        settings.copyWith(
          driveBackupEnabled: true,
          driveAccountEmail: account.email,
        ),
      );
    } else {
      await _driveService.signOut();
      await _settingsController.save(
        settings.copyWith(
          driveBackupEnabled: false,
          driveAccountEmail: null,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> backupNow() async {
    _lastError = null;
    _isBackingUp = true;
    notifyListeners();
    try {
      final file = await _backupService.createBackupFile(
        settings: settings,
        agencies: _agenciesRepository.current(),
        transactions: _transactionsRepository.current(),
      );
      if (settings.driveBackupEnabled) {
        final fileId = await _driveService.uploadFile(file);
        if (fileId == null) {
          throw Exception('Google Drive account not connected.');
        }
      }
      await _settingsController.save(
        settings.copyWith(lastDriveBackup: DateTime.now()),
      );
    } catch (error) {
      _lastError = error.toString();
    } finally {
      _isBackingUp = false;
      notifyListeners();
    }
  }

  Future<void> maybeBackupDaily() async {
    if (!settings.driveBackupEnabled) {
      return;
    }
    final last = settings.lastDriveBackup;
    final now = DateTime.now();
    if (last == null || !_isSameDay(last, now)) {
      await backupNow();
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void dispose() {
    _settingsController.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
