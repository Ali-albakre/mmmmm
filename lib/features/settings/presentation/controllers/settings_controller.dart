import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._repository);

  final SettingsRepository _repository;
  StreamSubscription<AppSettings>? _subscription;
  AppSettings _settings = AppSettings.defaults();
  bool _isLoaded = false;

  AppSettings get settings => _settings;
  bool get isConfigured => _isLoaded && _settings.isConfigured;

  Locale get locale {
    switch (_settings.locale) {
      case AppLocale.ar:
        return const Locale('ar');
      case AppLocale.en:
        return const Locale('en');
    }
  }

  Future<void> load() async {
    _settings = await _repository.load() ?? AppSettings.defaults();
    _isLoaded = true;
    notifyListeners();
    _subscription?.cancel();
    _subscription = _repository.watch().listen((event) {
      _settings = event;
      notifyListeners();
    });
  }

  Future<void> save(AppSettings settings) async {
    await _repository.save(settings);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
