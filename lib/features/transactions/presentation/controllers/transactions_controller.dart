import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transactions_repository.dart';

class TransactionsController extends ChangeNotifier {
  TransactionsController(this._repository);

  final TransactionsRepository _repository;
  StreamSubscription<List<Transaction>>? _subscription;
  List<Transaction> _transactions = [];
  bool _isLoaded = false;

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    await _repository.load();
    _transactions = _repository.current();
    _isLoaded = true;
    notifyListeners();
    _subscription?.cancel();
    _subscription = _repository.watch().listen((txns) {
      _transactions = txns;
      notifyListeners();
    });
  }

  Future<void> add(Transaction transaction) async {
    await _repository.add(transaction);
  }

  Future<void> update(Transaction transaction) async {
    await _repository.update(transaction);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
