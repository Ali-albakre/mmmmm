import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/entities/agency.dart';
import '../../domain/repositories/agencies_repository.dart';

class AgenciesController extends ChangeNotifier {
  AgenciesController(this._repository);

  final AgenciesRepository _repository;
  StreamSubscription<List<Agency>>? _subscription;
  List<Agency> _agencies = [];
  String? _selectedId;
  bool _isLoaded = false;

  List<Agency> get agencies => List.unmodifiable(_agencies);
  String? get selectedAgencyId => _selectedId;
  bool get isLoaded => _isLoaded;

  Agency? get selectedAgency {
    if (_selectedId == null) {
      return null;
    }
    for (final agency in _agencies) {
      if (agency.id == _selectedId) {
        return agency;
      }
    }
    return _agencies.isNotEmpty ? _agencies.first : null;
  }

  Future<void> load() async {
    await _repository.load();
    _agencies = _repository.current();
    _selectedId = _repository.selectedAgencyId();
    _isLoaded = true;
    notifyListeners();
    _subscription?.cancel();
    _subscription = _repository.watch().listen((agencies) {
      _agencies = agencies;
      _selectedId = _repository.selectedAgencyId();
      notifyListeners();
    });
  }

  Future<void> addAgency(Agency agency) async {
    await _repository.addAgency(agency);
  }

  Future<void> selectAgency(String agencyId) async {
    await _repository.selectAgency(agencyId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
