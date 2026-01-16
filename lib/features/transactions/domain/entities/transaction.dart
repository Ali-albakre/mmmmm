import 'package:equatable/equatable.dart';

import '../../../settings/domain/entities/app_settings.dart';

enum TransactionType {
  purchaseCredit,
  payment,
  returnTxn,
  openingBalance,
  purchaseCash,
  compensation,
}

enum TransactionSource { manual, ocr }

enum TransactionStatus { posted, draft }

class TransactionLineItem extends Equatable {
  const TransactionLineItem({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  final String name;
  final String? unit;
  final num quantity;
  final num unitPrice;
  final num totalPrice;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory TransactionLineItem.fromJson(Map<String, dynamic> json) {
    return TransactionLineItem(
      name: json['name'] as String,
      unit: json['unit'] as String?,
      quantity: json['quantity'] as num,
      unitPrice: json['unitPrice'] as num,
      totalPrice: json['totalPrice'] as num,
    );
  }

  @override
  List<Object?> get props => [name, unit, quantity, unitPrice, totalPrice];
}

class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.agencyId,
    required this.type,
    required this.currency,
    required this.invoiceNumber,
    required this.amount,
    required this.amountInBase,
    required this.exchangeRate,
    required this.date,
    required this.notes,
    required this.source,
    required this.status,
    this.items = const [],
  });

  final String id;
  final String agencyId;
  final TransactionType type;
  final CurrencyCode currency;
  final String? invoiceNumber;
  final num amount;
  final num amountInBase;
  final num? exchangeRate;
  final DateTime date;
  final String? notes;
  final TransactionSource source;
  final TransactionStatus status;
  final List<TransactionLineItem> items;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agencyId': agencyId,
      'type': type.name,
      'currency': currency.name,
      'invoiceNumber': invoiceNumber,
      'amount': amount,
      'amountInBase': amountInBase,
      'exchangeRate': exchangeRate,
      'date': date.toIso8601String(),
      'notes': notes,
      'source': source.name,
      'status': status.name,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      agencyId: json['agencyId'] as String,
      type: _parseType(json['type'] as String?),
      currency: CurrencyCode.values.firstWhere(
        (value) => value.name == json['currency'],
        orElse: () => CurrencyCode.yer,
      ),
      invoiceNumber: json['invoiceNumber'] as String?,
      amount: json['amount'] as num? ?? 0,
      amountInBase:
          json['amountInBase'] as num? ?? (json['amount'] as num? ?? 0),
      exchangeRate: json['exchangeRate'] as num?,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      source: TransactionSource.values.firstWhere(
        (value) => value.name == json['source'],
        orElse: () => TransactionSource.manual,
      ),
      status: TransactionStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => TransactionStatus.posted,
      ),
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => TransactionLineItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }

  static TransactionType _parseType(String? value) {
    switch (value) {
      case 'purchase':
        return TransactionType.purchaseCredit;
      case 'disbursement':
        return TransactionType.payment;
      case 'opening':
        return TransactionType.openingBalance;
      case 'purchaseCredit':
        return TransactionType.purchaseCredit;
      case 'payment':
        return TransactionType.payment;
      case 'returnTxn':
        return TransactionType.returnTxn;
      case 'openingBalance':
        return TransactionType.openingBalance;
      case 'purchaseCash':
        return TransactionType.purchaseCash;
      case 'compensation':
        return TransactionType.compensation;
      default:
        return TransactionType.purchaseCredit;
    }
  }

  @override
  List<Object?> get props => [
    id,
    agencyId,
    type,
    currency,
    invoiceNumber,
    amount,
    amountInBase,
    exchangeRate,
    date,
    notes,
    source,
    status,
    items,
  ];
}
