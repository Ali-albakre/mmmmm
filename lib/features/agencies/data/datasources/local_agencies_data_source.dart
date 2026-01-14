import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/agency.dart';

class LocalAgenciesDataSource {
  LocalAgenciesDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _keyAgencies = 'agencies.list';
  static const _keySelected = 'agencies.selected';

  List<Agency> loadAgencies() {
    final raw = _prefs.getString(_keyAgencies);
    if (raw == null || raw.trim().isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((item) => Agency.fromJson(item as Map<String, dynamic>)).toList();
  }

  String? loadSelectedAgency() {
    return _prefs.getString(_keySelected);
  }

  Future<void> saveAgencies(List<Agency> agencies) async {
    final jsonList = agencies.map((agency) => agency.toJson()).toList();
    await _prefs.setString(_keyAgencies, jsonEncode(jsonList));
  }

  Future<void> saveSelectedAgency(String agencyId) async {
    await _prefs.setString(_keySelected, agencyId);
  }
}
