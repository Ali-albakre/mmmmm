import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/transaction.dart';

class LocalTransactionsDataSource {
  LocalTransactionsDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _keyTransactions = 'transactions.list';

  List<Transaction> loadTransactions() {
    final raw = _prefs.getString(_keyTransactions);
    if (raw == null || raw.trim().isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    final jsonList = transactions.map((txn) => txn.toJson()).toList();
    await _prefs.setString(_keyTransactions, jsonEncode(jsonList));
  }
}
