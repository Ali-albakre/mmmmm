import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mmmmm/app/di.dart';
import 'package:mmmmm/features/agencies/presentation/controllers/agencies_controller.dart';
import 'package:mmmmm/features/transactions/domain/entities/transaction.dart';
import 'package:mmmmm/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:mmmmm/features/manual_entry/presentation/screens/manual_entry_screen.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

class RecentOperationsScreen extends StatelessWidget {
  const RecentOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final agenciesController = getIt<AgenciesController>();
    final transactionsController = getIt<TransactionsController>();
    final localeTag = l10n.localeName;
    final dateFormatter = DateFormat.yMMMd(localeTag);

    return AnimatedBuilder(
      animation: Listenable.merge([agenciesController, transactionsController]),
      builder: (context, _) {
        final selectedAgency = agenciesController.selectedAgency;
        final transactions = transactionsController.transactions
            .where((txn) =>
                txn.agencyId == selectedAgency?.id &&
                txn.type != TransactionType.openingBalance)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.recentOperationsTitle),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _TableHeader(
                documentLabel: l10n.dashboardColumnDocument,
                typeLabel: l10n.dashboardColumnType,
                dateLabel: l10n.dashboardColumnDate,
                amountLabel: l10n.reportsColumnAmount,
              ),
              const SizedBox(height: 8),
              if (transactions.isEmpty)
                _EmptyState(
                  icon: Icons.receipt_long,
                  message: l10n.recentOperationsEmpty,
                )
              else
                ...transactions.map(
                  (txn) => _Row(
                    document: txn.invoiceNumber ?? '-',
                    type: _typeLabel(txn.type, l10n),
                    date: dateFormatter.format(txn.date),
                    amount: txn.amountInBase.toStringAsFixed(0),
                    status: _statusLabel(txn.status, l10n),
                    statusColor: _statusColor(txn.status),
                    onEdit: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ManualEntryScreen(existingTransaction: txn),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _typeLabel(TransactionType type, AppLocalizations l10n) {
    switch (type) {
      case TransactionType.purchaseCredit:
        return l10n.transactionTypePurchaseCredit;
      case TransactionType.payment:
        return l10n.transactionTypePayment;
      case TransactionType.returnTxn:
        return l10n.transactionTypeReturn;
      case TransactionType.openingBalance:
        return l10n.transactionTypeOpeningBalance;
      case TransactionType.purchaseCash:
        return l10n.transactionTypePurchaseCash;
      case TransactionType.compensation:
        return l10n.transactionTypeCompensation;
    }
  }

  String _statusLabel(TransactionStatus status, AppLocalizations l10n) {
    switch (status) {
      case TransactionStatus.posted:
        return l10n.transactionStatusPosted;
      case TransactionStatus.draft:
        return l10n.transactionStatusDraft;
    }
  }

  Color _statusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.posted:
        return const Color(0xFF16A34A);
      case TransactionStatus.draft:
        return const Color(0xFFF59E0B);
    }
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({
    required this.documentLabel,
    required this.typeLabel,
    required this.dateLabel,
    required this.amountLabel,
  });

  final String documentLabel;
  final String typeLabel;
  final String dateLabel;
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EAF4)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(documentLabel)),
          Expanded(flex: 2, child: Text(typeLabel)),
          Expanded(flex: 3, child: Text(dateLabel)),
          Expanded(flex: 2, child: Text(amountLabel)),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.document,
    required this.type,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.onEdit,
  });

  final String document;
  final String type;
  final String date;
  final String amount;
  final String status;
  final Color statusColor;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(document)),
            Expanded(flex: 2, child: Text(type)),
            Expanded(flex: 3, child: Text(date)),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(amount),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: onEdit,
                    tooltip: status,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
