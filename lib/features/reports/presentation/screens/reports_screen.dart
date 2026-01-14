import 'dart:io';

import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mmmmm/app/di.dart';
import 'package:mmmmm/features/agencies/presentation/controllers/agencies_controller.dart';
import 'package:mmmmm/features/transactions/domain/entities/transaction.dart';
import 'package:mmmmm/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:mmmmm/l10n/app_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  _ReportType _reportType = _ReportType.statement;
  _ReportFormat _format = _ReportFormat.pdf;
  DateTimeRange? _range;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final agenciesController = getIt<AgenciesController>();
    final transactionsController = getIt<TransactionsController>();
    final selectedAgency = agenciesController.selectedAgency;
    final transactions = transactionsController.transactions
        .where((txn) =>
            txn.agencyId == selectedAgency?.id &&
            txn.status == TransactionStatus.posted &&
            txn.type != TransactionType.openingBalance)
        .toList();
    final filtered = _filterTransactions(transactions);
    final dateFormatter = DateFormat.yMMMd(l10n.localeName);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportsTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionTitle(title: l10n.reportsSetupTitle),
            const SizedBox(height: 12),
            DropdownButtonFormField<_ReportType>(
              initialValue: _reportType,
              decoration: InputDecoration(labelText: l10n.reportsTypeLabel),
              items: _ReportType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label(l10n)),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _reportType = value ?? _reportType),
            ),
            const SizedBox(height: 12),
            _DateRangePickerField(
              label: l10n.reportsPeriodLabel,
              range: _range,
              onChanged: (range) => setState(() => _range = range),
            ),
            const SizedBox(height: 12),
            _FormatSelector(
              format: _format,
              onChanged: (format) => setState(() => _format = format),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : () => _generateReport(filtered),
                child: Text(_isGenerating ? l10n.reportsGenerating : l10n.reportsGenerate),
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: l10n.reportsTableTitle),
            const SizedBox(height: 8),
            _ReportTableHeader(
              documentLabel: l10n.dashboardColumnDocument,
              typeLabel: l10n.dashboardColumnType,
              dateLabel: l10n.dashboardColumnDate,
              amountLabel: l10n.reportsColumnAmount,
            ),
            const SizedBox(height: 8),
            if (filtered.isEmpty)
              _EmptyState(icon: Icons.table_chart, message: l10n.reportsEmpty)
            else
              ...filtered.map(
                (txn) => _ReportRow(
                  document: txn.invoiceNumber ?? '-',
                  type: _typeLabel(txn.type, l10n),
                  date: dateFormatter.format(txn.date),
                  amount: txn.amountInBase.toStringAsFixed(0),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    var filtered = transactions;
    switch (_reportType) {
      case _ReportType.statement:
        break;
      case _ReportType.monthlySummary:
        break;
      case _ReportType.purchases:
        filtered =
            transactions.where((txn) => txn.type == TransactionType.purchaseCredit).toList();
        break;
      case _ReportType.payments:
        filtered =
            transactions.where((txn) => txn.type == TransactionType.payment).toList();
        break;
      case _ReportType.returns:
        filtered = transactions.where((txn) => txn.type == TransactionType.returnTxn).toList();
        break;
      case _ReportType.purchaseCash:
        filtered =
            transactions.where((txn) => txn.type == TransactionType.purchaseCash).toList();
        break;
      case _ReportType.compensation:
        filtered =
            transactions.where((txn) => txn.type == TransactionType.compensation).toList();
        break;
    }
    if (_range != null) {
      filtered = filtered
          .where((txn) =>
              !txn.date.isBefore(_range!.start) && !txn.date.isAfter(_range!.end))
          .toList();
    }
    return filtered;
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

  Future<void> _generateReport(List<Transaction> transactions) async {
    final l10n = AppLocalizations.of(context)!;
    if (transactions.isEmpty) {
      _showSnack(l10n.reportsNoDataToExport);
      return;
    }
    setState(() => _isGenerating = true);
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'report_${DateTime.now().millisecondsSinceEpoch}';
      if (_format == _ReportFormat.pdf) {
        final file = File(p.join(directory.path, '$fileName.pdf'));
        await _writePdf(file, transactions, l10n);
        await _confirmSaved(file, l10n);
      } else {
        final file = File(p.join(directory.path, '$fileName.xlsx'));
        await _writeExcel(file, transactions, l10n);
        await _confirmSaved(file, l10n);
      }
    } catch (error) {
      _showSnack(l10n.reportsExportFailed);
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  Future<void> _writePdf(
    File file,
    List<Transaction> transactions,
    AppLocalizations l10n,
  ) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Smart Accounting Report'),
              pw.SizedBox(height: 12),
              pw.Table.fromTextArray(
                headers: ['Document', 'Type', 'Date', 'Amount'],
                data: transactions
                    .map(
                      (txn) => [
                        txn.invoiceNumber ?? '-',
                        _typeLabel(txn.type, l10n),
                        txn.date.toIso8601String().split('T').first,
                        txn.amountInBase.toStringAsFixed(0),
                      ],
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
    await file.writeAsBytes(await doc.save());
  }

  Future<void> _writeExcel(
    File file,
    List<Transaction> transactions,
    AppLocalizations l10n,
  ) async {
    final excel = ex.Excel.createExcel();
    final sheet = excel['Report'];
    sheet.appendRow(<ex.CellValue?>[
      ex.TextCellValue('Document'),
      ex.TextCellValue('Type'),
      ex.TextCellValue('Date'),
      ex.TextCellValue('Amount'),
    ]);
    for (final txn in transactions) {
      sheet.appendRow(<ex.CellValue?>[
        ex.TextCellValue(txn.invoiceNumber ?? '-'),
        ex.TextCellValue(_typeLabel(txn.type, l10n)),
        ex.TextCellValue(txn.date.toIso8601String().split('T').first),
        ex.DoubleCellValue(txn.amountInBase.toDouble()),
      ]);
    }
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes, flush: true);
    }
  }

  Future<void> _confirmSaved(File file, AppLocalizations l10n) async {
    final exists = await file.exists();
    if (!exists) {
      _showSnack(l10n.reportsCreatedNoFile);
      return;
    }
    final length = await file.length();
    if (length <= 0) {
      _showSnack(l10n.reportsCreatedNoFile);
      return;
    }
    _showSnack(l10n.reportsSaved(file.path));
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

enum _ReportType {
  statement,
  monthlySummary,
  purchases,
  payments,
  returns,
  purchaseCash,
  compensation,
}

enum _ReportFormat { pdf, excel }

extension _ReportTypeLabel on _ReportType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case _ReportType.statement:
        return l10n.reportsTypeStatement;
      case _ReportType.monthlySummary:
        return l10n.reportsTypeMonthlySummary;
      case _ReportType.purchases:
        return l10n.reportsTypePurchasesCredit;
      case _ReportType.payments:
        return l10n.reportsTypePayments;
      case _ReportType.returns:
        return l10n.reportsTypeReturns;
      case _ReportType.purchaseCash:
        return l10n.reportsTypePurchasesCash;
      case _ReportType.compensation:
        return l10n.reportsTypeCompensation;
    }
  }
}

class _DateRangePickerField extends StatelessWidget {
  const _DateRangePickerField({
    required this.label,
    required this.range,
    required this.onChanged,
  });

  final String label;
  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = DateFormat.yMMMd(l10n.localeName);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final now = DateTime.now();
        final result = await showDateRangePicker(
          context: context,
          firstDate: DateTime(now.year - 5),
          lastDate: now,
          initialDateRange: range,
        );
        onChanged(result);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          range == null
              ? l10n.reportsPeriodHint
              : '${formatter.format(range!.start)} - ${formatter.format(range!.end)}',
        ),
      ),
    );
  }
}

class _FormatSelector extends StatelessWidget {
  const _FormatSelector({required this.format, required this.onChanged});

  final _ReportFormat format;
  final ValueChanged<_ReportFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedButton<_ReportFormat>(
      segments: [
        ButtonSegment(value: _ReportFormat.pdf, label: Text(l10n.reportsFormatPdf)),
        ButtonSegment(value: _ReportFormat.excel, label: Text(l10n.reportsFormatExcel)),
      ],
      selected: {format},
      onSelectionChanged: (selected) => onChanged(selected.first),
    );
  }
}

class _ReportTableHeader extends StatelessWidget {
  const _ReportTableHeader({
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

class _ReportRow extends StatelessWidget {
  const _ReportRow({
    required this.document,
    required this.type,
    required this.date,
    required this.amount,
  });

  final String document;
  final String type;
  final String date;
  final String amount;

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
            Expanded(flex: 2, child: Text(amount)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
