import 'dart:async';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/local_transactions_data_source.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl(this._dataSource);

  final LocalTransactionsDataSource _dataSource;
  final StreamController<List<Transaction>> _controller =
      StreamController<List<Transaction>>.broadcast();
  List<Transaction> _transactions = [];

  @override
  List<Transaction> current() => List.unmodifiable(_transactions);

  @override
  Stream<List<Transaction>> watch() => _controller.stream;

  @override
  Future<void> load() async {
    _transactions = _dataSource.loadTransactions();
    _controller.add(current());
  }

  @override
  Future<void> add(Transaction transaction) async {
    _transactions = [transaction, ..._transactions];
    await _dataSource.saveTransactions(_transactions);
    _controller.add(current());
  }

  @override
  Future<void> update(Transaction transaction) async {
    final index = _transactions.indexWhere((item) => item.id == transaction.id);
    if (index == -1) {
      return;
    }
    final updated = List<Transaction>.from(_transactions);
    updated[index] = transaction;
    _transactions = updated;
    await _dataSource.saveTransactions(_transactions);
    _controller.add(current());
  }
}
