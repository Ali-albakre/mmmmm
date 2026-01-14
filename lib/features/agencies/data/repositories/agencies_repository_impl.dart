import 'dart:async';

import '../../domain/entities/agency.dart';
import '../../domain/repositories/agencies_repository.dart';
import '../datasources/local_agencies_data_source.dart';

class AgenciesRepositoryImpl implements AgenciesRepository {
  AgenciesRepositoryImpl(this._dataSource);

  final LocalAgenciesDataSource _dataSource;
  final StreamController<List<Agency>> _controller =
      StreamController<List<Agency>>.broadcast();
  List<Agency> _agencies = [];
  String? _selectedId;

  @override
  List<Agency> current() => List.unmodifiable(_agencies);

  @override
  String? selectedAgencyId() => _selectedId;

  @override
  Stream<List<Agency>> watch() => _controller.stream;

  @override
  Future<void> load() async {
    _agencies = _dataSource.loadAgencies();
    _selectedId = _dataSource.loadSelectedAgency();
    if (_selectedId == null && _agencies.isNotEmpty) {
      _selectedId = _agencies.first.id;
    }
    _controller.add(current());
  }

  @override
  Future<void> addAgency(Agency agency) async {
    _agencies = [agency, ..._agencies];
    _selectedId ??= agency.id;
    await _dataSource.saveAgencies(_agencies);
    if (_selectedId != null) {
      await _dataSource.saveSelectedAgency(_selectedId!);
    }
    _controller.add(current());
  }

  @override
  Future<void> selectAgency(String agencyId) async {
    _selectedId = agencyId;
    await _dataSource.saveSelectedAgency(agencyId);
    _controller.add(current());
  }
}
