import 'package:equatable/equatable.dart';

import '../../../settings/domain/entities/app_settings.dart';

class Agency extends Equatable {
  const Agency({
    required this.id,
    required this.name,
    required this.openingBalance,
    required this.openingBalanceDate,
    required this.primaryCurrency,
    required this.allowedCurrencies,
    required this.createdAt,
  });

  final String id;
  final String name;
  final num openingBalance;
  final DateTime openingBalanceDate;
  final CurrencyCode primaryCurrency;
  final List<CurrencyCode> allowedCurrencies;
  final DateTime createdAt;

  Agency copyWith({
    String? id,
    String? name,
    num? openingBalance,
    DateTime? openingBalanceDate,
    CurrencyCode? primaryCurrency,
    List<CurrencyCode>? allowedCurrencies,
    DateTime? createdAt,
  }) {
    return Agency(
      id: id ?? this.id,
      name: name ?? this.name,
      openingBalance: openingBalance ?? this.openingBalance,
      openingBalanceDate: openingBalanceDate ?? this.openingBalanceDate,
      primaryCurrency: primaryCurrency ?? this.primaryCurrency,
      allowedCurrencies: allowedCurrencies ?? this.allowedCurrencies,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'openingBalance': openingBalance,
      'openingBalanceDate': openingBalanceDate.toIso8601String(),
      'primaryCurrency': primaryCurrency.name,
      'allowedCurrencies': allowedCurrencies.map((item) => item.name).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Agency.fromJson(Map<String, dynamic> json) {
    final primary = CurrencyCode.values.firstWhere(
      (value) => value.name == json['primaryCurrency'],
      orElse: () => CurrencyCode.yer,
    );
    final allowedRaw = json['allowedCurrencies'] as List<dynamic>?;
    final allowed = allowedRaw
            ?.map((item) => CurrencyCode.values.firstWhere(
                  (value) => value.name == item,
                  orElse: () => primary,
                ))
            .toSet()
            .toList() ??
        [primary];
    return Agency(
      id: json['id'] as String,
      name: json['name'] as String,
      openingBalance: json['openingBalance'] as num? ?? 0,
      openingBalanceDate: DateTime.tryParse(
            json['openingBalanceDate'] as String? ?? '',
          ) ??
          DateTime(DateTime.now().year, 1, 1),
      primaryCurrency: primary,
      allowedCurrencies: allowed,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        openingBalance,
        openingBalanceDate,
        primaryCurrency,
        allowedCurrencies,
        createdAt,
      ];
}
