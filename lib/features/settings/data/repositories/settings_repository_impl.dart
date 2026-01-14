import 'dart:async';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_settings_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._dataSource);

  final LocalSettingsDataSource _dataSource;
  final StreamController<AppSettings> _controller =
      StreamController<AppSettings>.broadcast();
  AppSettings? _current;

  @override
  AppSettings? current() => _current;

  @override
  Stream<AppSettings> watch() => _controller.stream;

  @override
  Future<AppSettings?> load() async {
    _current = _dataSource.read() ?? AppSettings.defaults();
    _controller.add(_current!);
    return _current;
  }

  @override
  Future<void> save(AppSettings settings) async {
    final next = settings.copyWith(isConfigured: true);
    await _dataSource.save(next);
    _current = next;
    _controller.add(next);
  }
}
