import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mmmmm/app/di.dart';
import 'package:mmmmm/core/ocr/ocr_parser.dart';
import 'package:mmmmm/core/ocr/ocr_service.dart';
import 'package:mmmmm/features/agencies/presentation/controllers/agencies_controller.dart';
import 'package:mmmmm/features/settings/domain/entities/app_settings.dart';
import 'package:mmmmm/features/settings/presentation/controllers/settings_controller.dart';
import 'package:mmmmm/features/transactions/domain/entities/transaction.dart';
import 'package:mmmmm/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

const _borderColor = Color(0xFFE2E8F0);

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({
    super.key,
    this.attachmentImages,
    this.attachmentPdf,
    this.existingTransaction,
    this.prefillOcr,
  });

  final List<File>? attachmentImages;
  final File? attachmentPdf;
  final Transaction? existingTransaction;
  final OcrResult? prefillOcr;

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late final OcrService _ocrService;

  DateTime? _txnDate;
  String? _transactionType;
  CurrencyCode? _currencyCode;
  bool _isOcrLoading = false;
  OcrResult? _ocrResult;
  String? _ocrError;
  bool _didPrefillExisting = false;
  final List<_LineItemControllers> _lineItems = [];

  @override
  void initState() {
    super.initState();
    _ocrService = OcrService();
    if (widget.prefillOcr != null) {
      _ocrResult = widget.prefillOcr;
      _prefillFromOcr(widget.prefillOcr!);
    } else {
      _startOcrIfNeeded();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrefillExisting) {
      return;
    }
    final transaction = widget.existingTransaction;
    if (transaction == null) {
      _didPrefillExisting = true;
      _currencyCode ??= _baseCurrency();
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    _didPrefillExisting = true;
    _invoiceController.text = transaction.invoiceNumber ?? '';
    _amountController.text = transaction.amount.toString();
    _currencyCode = transaction.currency;
    if (transaction.exchangeRate != null) {
      _exchangeRateController.text = transaction.exchangeRate.toString();
    }
    _notesController.text = transaction.notes ?? '';
    _txnDate = transaction.date;
    _dateController.text = MaterialLocalizations.of(
      context,
    ).formatFullDate(transaction.date);
    _transactionType = _labelForTransactionType(transaction.type, l10n);

    // Pre-fill line items
    if (_lineItems.isEmpty) {
      for (final item in transaction.items) {
        _lineItems.add(
          _LineItemControllers(
            name: item.name,
            unit: item.unit ?? '',
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            onUpdate: _updateTotalAmount,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _invoiceController.dispose();
    _amountController.dispose();
    _exchangeRateController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    for (final item in _lineItems) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final baseCurrency = _baseCurrency();
    final selectedCurrency = _currencyCode ?? baseCurrency;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(title: Text(l10n.manualEntryTitle)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if ((widget.attachmentImages?.isNotEmpty ?? false))
                _AttachmentGallery(images: widget.attachmentImages!),
              if (widget.attachmentPdf != null)
                _AttachmentPdf(
                  fileName: widget.attachmentPdf!.path
                      .split(Platform.pathSeparator)
                      .last,
                ),
              const SizedBox(height: 12),
              _OcrStatusCard(
                isLoading: _isOcrLoading,
                ocrResult: _ocrResult,
                errorMessage: _ocrError,
                pdfSelected: widget.attachmentPdf != null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(title: l10n.manualEntryDetailsTitle),
                  TextButton.icon(
                    onPressed: _addLineItem,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.manualEntryAddItem),
                  ),
                ],
              ),
              if (_lineItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                ..._lineItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return _LineItemWidget(
                    key: ObjectKey(item),
                    controllers: item,
                    onDelete: () => _removeLineItem(index),
                  );
                }),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _invoiceController,
                decoration: InputDecoration(
                  labelText: l10n.manualEntryInvoiceNumber,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.manualEntryAmount),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.manualEntryAmountRequired;
                  }
                  final parsed = num.tryParse(value.replaceAll(',', ''));
                  if (parsed == null || parsed <= 0) {
                    return l10n.manualEntryAmountInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<CurrencyCode>(
                initialValue: selectedCurrency,
                decoration: InputDecoration(
                  labelText: l10n.manualEntryCurrency,
                ),
                items: _allowedCurrencies()
                    .map(
                      (currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(_currencyLabel(currency, l10n)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _currencyCode = value),
              ),
              if (selectedCurrency != baseCurrency) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _exchangeRateController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.manualEntryExchangeRate,
                  ),
                  validator: (value) {
                    final parsed = num.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return l10n.manualEntryExchangeRateRequired;
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 12),
              _DatePickerField(
                label: l10n.manualEntryDate,
                value: _txnDate,
                controller: _dateController,
                onChanged: (value) => setState(() => _txnDate = value),
                onTextChanged: (value) {
                  final parsed = _parseManualDate(value);
                  if (parsed != null) {
                    setState(() => _txnDate = parsed);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _transactionType,
                decoration: InputDecoration(
                  labelText: l10n.manualEntryTransactionType,
                ),
                items:
                    [
                          l10n.transactionTypePurchaseCredit,
                          l10n.transactionTypePayment,
                          l10n.transactionTypeReturn,
                          l10n.transactionTypePurchaseCash,
                          l10n.transactionTypeCompensation,
                        ]
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                validator: (value) => value == null
                    ? l10n.manualEntryTransactionTypeRequired
                    : null,
                onChanged: (value) => setState(() => _transactionType = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(labelText: l10n.manualEntryNotes),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _submit(TransactionStatus.draft),
                      child: Text(l10n.manualEntrySaveDraft),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submit(TransactionStatus.posted),
                      child: Text(l10n.manualEntryPost),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startOcrIfNeeded() async {
    if (widget.existingTransaction != null) {
      return;
    }
    if (widget.attachmentPdf != null) {
      setState(() => _ocrError = 'pdf');
      return;
    }
    final images = widget.attachmentImages ?? [];
    if (images.isEmpty) {
      return;
    }
    setState(() {
      _isOcrLoading = true;
      _ocrError = null;
    });
    try {
      final result = await _ocrService.recognize(images);
      _ocrResult = result;
      _prefillFromOcr(result);
    } catch (error) {
      _ocrError = error.toString();
    } finally {
      if (mounted) {
        setState(() => _isOcrLoading = false);
      }
    }
  }

  void _prefillFromOcr(OcrResult result) {
    if (_invoiceController.text.trim().isEmpty &&
        result.invoiceNumber != null) {
      _invoiceController.text = result.invoiceNumber!;
    }
    if (_amountController.text.trim().isEmpty && result.totalAmount != null) {
      _amountController.text = result.totalAmount!.toString();
    }
    if (_txnDate == null && result.date != null) {
      _txnDate = result.date;
      _dateController.text = _formatDate(
        result.date!.year,
        result.date!.month,
        result.date!.day,
      );
    }
    if (_currencyCode == null && result.currency != null) {
      _currencyCode = result.currency;
    }
    if (_lineItems.isEmpty && result.items.isNotEmpty) {
      for (final item in result.items) {
        _lineItems.add(
          _LineItemControllers(
            name: item.name,
            unit: item.unit ?? '',
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            onUpdate: _updateTotalAmount,
          ),
        );
      }
      _updateTotalAmount();
    }
  }

  void _addLineItem() {
    setState(() {
      _lineItems.add(
        _LineItemControllers(
          name: '',
          unit: '',
          quantity: 1,
          unitPrice: 0,
          totalPrice: 0,
          onUpdate: _updateTotalAmount,
        ),
      );
    });
  }

  void _removeLineItem(int index) {
    setState(() {
      final item = _lineItems.removeAt(index);
      item.dispose();
      _updateTotalAmount();
    });
  }

  void _updateTotalAmount() {
    num total = 0;
    for (final item in _lineItems) {
      total += num.tryParse(item.totalPriceController.text) ?? 0;
    }
    if (total > 0) {
      _amountController.text = total.toString();
    }
  }

  Future<void> _submit(TransactionStatus status) async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_txnDate == null) {
      _showSnack(l10n.manualEntryDateRequired);
      return;
    }
    final agenciesController = getIt<AgenciesController>();
    final agencyId = agenciesController.selectedAgencyId;
    if (agencyId == null) {
      _showSnack(l10n.manualEntryNoAgency);
      return;
    }
    final baseCurrency = _baseCurrency();
    final selectedCurrency = _currencyCode ?? baseCurrency;
    final exchangeRate = _resolveExchangeRate(baseCurrency, selectedCurrency);
    if (exchangeRate == null) {
      _showSnack(l10n.manualEntryExchangeRateRequired);
      return;
    }
    final amount = num.parse(_amountController.text.replaceAll(',', ''));
    final amountInBase = selectedCurrency == baseCurrency
        ? amount
        : amount * exchangeRate;

    final base = widget.existingTransaction;
    final transaction = Transaction(
      id: base?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      agencyId: base?.agencyId ?? agencyId,
      type: _mapTransactionType(l10n),
      currency: selectedCurrency,
      invoiceNumber: _invoiceController.text.trim().isEmpty
          ? null
          : _invoiceController.text.trim(),
      amount: amount,
      amountInBase: amountInBase,
      exchangeRate: selectedCurrency == baseCurrency ? null : exchangeRate,
      date: _txnDate!,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      source:
          base?.source ??
          ((widget.attachmentImages?.isNotEmpty ?? false)
              ? TransactionSource.ocr
              : TransactionSource.manual),
      status: status,
      items: _lineItems.map((e) => e.toLineItem()).toList(),
    );

    if (base == null) {
      await getIt<TransactionsController>().add(transaction);
    } else {
      await getIt<TransactionsController>().update(transaction);
    }

    if (!mounted) {
      return;
    }
    _showSnack(l10n.manualEntrySaved);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  TransactionType _mapTransactionType(AppLocalizations l10n) {
    switch (_transactionType) {
      case null:
        return TransactionType.purchaseCredit;
      case final value when value == l10n.transactionTypePayment:
        return TransactionType.payment;
      case final value when value == l10n.transactionTypeReturn:
        return TransactionType.returnTxn;
      case final value when value == l10n.transactionTypePurchaseCash:
        return TransactionType.purchaseCash;
      case final value when value == l10n.transactionTypeCompensation:
        return TransactionType.compensation;
      default:
        return TransactionType.purchaseCredit;
    }
  }

  String _labelForTransactionType(TransactionType type, AppLocalizations l10n) {
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

  CurrencyCode _baseCurrency() {
    final agenciesController = getIt<AgenciesController>();
    final settings = getIt<SettingsController>().settings;
    return agenciesController.selectedAgency?.primaryCurrency ??
        settings.currency;
  }

  List<CurrencyCode> _allowedCurrencies() {
    final agenciesController = getIt<AgenciesController>();
    final agency = agenciesController.selectedAgency;
    if (agency == null || agency.allowedCurrencies.isEmpty) {
      return [CurrencyCode.yer, CurrencyCode.sar];
    }
    return agency.allowedCurrencies;
  }

  String _currencyLabel(CurrencyCode code, AppLocalizations l10n) {
    return code == CurrencyCode.yer ? l10n.currencyYER : l10n.currencySAR;
  }

  num? _resolveExchangeRate(CurrencyCode base, CurrencyCode selected) {
    if (base == selected) {
      return 1;
    }
    return num.tryParse(_exchangeRateController.text.trim());
  }

  DateTime? _parseManualDate(String value) {
    final normalized = _normalizeDigits(value);
    final ymd = RegExp(
      r'(\\d{4})[./-](\\d{1,2})[./-](\\d{1,2})',
    ).firstMatch(normalized);
    if (ymd != null) {
      final year = int.tryParse(ymd.group(1) ?? '');
      final month = int.tryParse(ymd.group(2) ?? '');
      final day = int.tryParse(ymd.group(3) ?? '');
      if (year != null && month != null && day != null) {
        return DateTime.tryParse(_formatDate(year, month, day));
      }
    }
    final dmy = RegExp(
      r'(\\d{1,2})[./-](\\d{1,2})[./-](\\d{4})',
    ).firstMatch(normalized);
    if (dmy != null) {
      final day = int.tryParse(dmy.group(1) ?? '');
      final month = int.tryParse(dmy.group(2) ?? '');
      final year = int.tryParse(dmy.group(3) ?? '');
      if (year != null && month != null && day != null) {
        return DateTime.tryParse(_formatDate(year, month, day));
      }
    }
    return null;
  }

  String _formatDate(int year, int month, int day) {
    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');
    return '$year-$mm-$dd';
  }

  String _normalizeDigits(String text) {
    const arabic = 'ظ ظ،ظ¢ظ£ظ¤ظ¥ظ¦ظ§ظ¨ظ©';
    const eastern = 'غ°غ±غ²غ³غ´غµغ¶غ·غ¸غ¹';
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      final arabicIndex = arabic.indexOf(char);
      if (arabicIndex != -1) {
        buffer.write(arabicIndex.toString());
        continue;
      }
      final easternIndex = eastern.indexOf(char);
      if (easternIndex != -1) {
        buffer.write(easternIndex.toString());
        continue;
      }
      buffer.write(char);
    }
    return buffer.toString();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _OcrStatusCard extends StatelessWidget {
  const _OcrStatusCard({
    required this.isLoading,
    required this.ocrResult,
    required this.errorMessage,
    required this.pdfSelected,
  });

  final bool isLoading;
  final OcrResult? ocrResult;
  final String? errorMessage;
  final bool pdfSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasData =
        ocrResult?.invoiceNumber != null ||
        ocrResult?.totalAmount != null ||
        ocrResult?.date != null;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.manualEntryOcrTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.manualEntryOcrInProgress),
                ],
              )
            else if (pdfSelected)
              Text(l10n.manualEntryOcrPdfNotice)
            else if (errorMessage != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.manualEntryOcrFailed),
                  const SizedBox(height: 6),
                  Text(
                    l10n.manualEntryOcrFailedReason(errorMessage!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              )
            else if (hasData)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (ocrResult?.invoiceNumber != null)
                    _InfoChip(
                      label: l10n.manualEntryOcrInvoice(
                        ocrResult!.invoiceNumber!,
                      ),
                    ),
                  if (ocrResult?.date != null)
                    _InfoChip(
                      label: l10n.manualEntryOcrDate(
                        MaterialLocalizations.of(
                          context,
                        ).formatShortDate(ocrResult!.date!),
                      ),
                    ),
                  if (ocrResult?.totalAmount != null)
                    _InfoChip(
                      label: l10n.manualEntryOcrTotal(ocrResult!.totalAmount!),
                    ),
                ],
              )
            else
              Text(l10n.manualEntryOcrNoData),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: const Color(0xFF3B6AF6),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.value,
    required this.controller,
    required this.onChanged,
    required this.onTextChanged,
  });

  final String label;
  final DateTime? value;
  final TextEditingController controller;
  final ValueChanged<DateTime?> onChanged;
  final ValueChanged<String> onTextChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      keyboardType: TextInputType.datetime,
      onChanged: onTextChanged,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today_outlined),
          onPressed: () async {
            final now = DateTime.now();
            final selected = await showDatePicker(
              context: context,
              initialDate: value ?? now,
              firstDate: DateTime(now.year - 5),
              lastDate: now,
            );
            if (selected != null) {
              controller.text = MaterialLocalizations.of(
                context,
              ).formatFullDate(selected);
            }
            onChanged(selected);
          },
        ),
      ),
      controller: controller,
      validator: (_) => value == null ? l10n.manualEntryDateRequired : null,
    );
  }
}

class _AttachmentGallery extends StatelessWidget {
  const _AttachmentGallery({required this.images});

  final List<File> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              images[index],
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

class _AttachmentPdf extends StatelessWidget {
  const _AttachmentPdf({required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            const SizedBox(width: 8),
            Expanded(child: Text(fileName)),
          ],
        ),
      ),
    );
  }
}

class _LineItemWidget extends StatelessWidget {
  const _LineItemWidget({
    super.key,
    required this.controllers,
    required this.onDelete,
  });

  final _LineItemControllers controllers;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: controllers.nameController,
                  decoration: InputDecoration(
                    labelText: l10n.manualEntryItemName,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controllers.quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.manualEntryItemQuantity,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controllers.unitPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.manualEntryItemUnitPrice,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controllers.totalPriceController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: l10n.manualEntryItemTotal,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineItemControllers {
  _LineItemControllers({
    required String name,
    required String unit,
    required num quantity,
    required num unitPrice,
    required num totalPrice,
    required VoidCallback onUpdate,
  }) : nameController = TextEditingController(text: name),
       unitController = TextEditingController(text: unit),
       quantityController = TextEditingController(text: quantity.toString()),
       unitPriceController = TextEditingController(text: unitPrice.toString()),
       totalPriceController = TextEditingController(
         text: totalPrice.toString(),
       ) {
    nameController.addListener(onUpdate);
    unitController.addListener(onUpdate);
    quantityController.addListener(() {
      _calculateTotal();
      onUpdate();
    });
    unitPriceController.addListener(() {
      _calculateTotal();
      onUpdate();
    });
  }

  final TextEditingController nameController;
  final TextEditingController unitController;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  final TextEditingController totalPriceController;

  void _calculateTotal() {
    final qty = num.tryParse(quantityController.text) ?? 0;
    final price = num.tryParse(unitPriceController.text) ?? 0;
    totalPriceController.text = (qty * price).toString();
  }

  void dispose() {
    nameController.dispose();
    unitController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    totalPriceController.dispose();
  }

  TransactionLineItem toLineItem() {
    return TransactionLineItem(
      name: nameController.text,
      unit: unitController.text.isEmpty ? null : unitController.text,
      quantity: num.tryParse(quantityController.text) ?? 0,
      unitPrice: num.tryParse(unitPriceController.text) ?? 0,
      totalPrice: num.tryParse(totalPriceController.text) ?? 0,
    );
  }
}
