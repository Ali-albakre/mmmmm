import '../entities/transaction.dart';

abstract class TransactionsRepository {
  List<Transaction> current();
  Stream<List<Transaction>> watch();
  Future<void> load();
  Future<void> add(Transaction transaction);
  Future<void> update(Transaction transaction);
}
