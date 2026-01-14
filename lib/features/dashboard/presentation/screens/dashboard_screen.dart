import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mmmmm/app/di.dart';
import 'package:mmmmm/features/agencies/presentation/controllers/agencies_controller.dart';
import 'package:mmmmm/features/settings/domain/entities/app_settings.dart';
import 'package:mmmmm/features/settings/presentation/controllers/settings_controller.dart';
import 'package:mmmmm/features/transactions/domain/entities/transaction.dart';
import 'package:mmmmm/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final agenciesController = getIt<AgenciesController>();
    final transactionsController = getIt<TransactionsController>();
    return AnimatedBuilder(
      animation: Listenable.merge([agenciesController, transactionsController]),
      builder: (context, _) {
        final l10n = AppLocalizations.of(context)!;
        final settings = getIt<SettingsController>().settings;
        final localeTag = settings.locale == AppLocale.ar ? 'ar' : 'en';
        final dateFormatter = DateFormat.yMMMd(localeTag);
        final timeFormatter = DateFormat.jm(localeTag);
        final now = DateTime.now();
        final agencies = agenciesController.agencies;
        final selectedAgency = agenciesController.selectedAgency;
        final transactions = transactionsController.transactions
            .where((txn) => txn.agencyId == selectedAgency?.id)
            .toList();

        final primaryCurrency =
            selectedAgency?.primaryCurrency ?? settings.currency;
        final currencyCode = primaryCurrency == CurrencyCode.yer ? 'YER' : 'SAR';
        final currencyFormatter = NumberFormat.currency(
          locale: localeTag,
          name: currencyCode,
          symbol: currencyCode,
          decimalDigits: 0,
        );
        final totals = _Totals.fromTransactions(
          transactions: transactions,
          openingBalance: selectedAgency?.openingBalance ?? 0,
        );

        final kpis = <_KpiCardData>[
          _KpiCardData(
            title: l10n.dashboardNetBalance,
            value: currencyFormatter.format(totals.netBalance),
            icon: Icons.account_balance_wallet_outlined,
            iconBackground: const Color(0xFFE9F1FF),
            iconColor: const Color(0xFF4C78FF),
            trendLabel: totals.trendLabel,
            trendColor: totals.trendColor,
            helperLabel: l10n.dashboardPeriodMonthly,
          ),
          _KpiCardData(
            title: l10n.dashboardTotalPurchases,
            value: currencyFormatter.format(totals.purchasesCredit),
            icon: Icons.shopping_cart_outlined,
            iconBackground: const Color(0xFFFFF3E0),
            iconColor: const Color(0xFFFB923C),
            helperLabel: l10n.dashboardPeriodMonthly,
          ),
          _KpiCardData(
            title: l10n.dashboardReturns,
            value: currencyFormatter.format(totals.returnsAmount),
            icon: Icons.autorenew,
            iconBackground: const Color(0xFFF3E8FF),
            iconColor: const Color(0xFF8B5CF6),
            helperLabel: l10n.dashboardPeriodMonthly,
          ),
          _KpiCardData(
            title: l10n.dashboardDisbursements,
            value: currencyFormatter.format(totals.payments),
            icon: Icons.trending_up,
            iconBackground: const Color(0xFFFFE4E6),
            iconColor: const Color(0xFFEF4444),
            helperLabel: l10n.dashboardPeriodMonthly,
          ),
        ];

        final recent = transactions
            .where((txn) =>
                txn.status == TransactionStatus.posted &&
                txn.type != TransactionType.openingBalance)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        return Scaffold(
          backgroundColor: const Color(0xFFF6F8FC),
          drawer: const _DashboardDrawer(),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                Builder(
                  builder: (context) => _TopBar(
                    title: l10n.appTitle,
                    onMenuTap: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(height: 12),
                if (agencies.isEmpty)
                  _AgencyEmptyCard(
                    title: l10n.dashboardNoAgencyTitle,
                    subtitle: l10n.dashboardNoAgencySubtitle,
                    actionLabel: l10n.agenciesCreate,
                    onAction: () => context.push('/agencies'),
                  )
                else
                  _AgencyCard(
                    title: l10n.dashboardCurrentAgency,
                    agencyName: selectedAgency?.name ?? agencies.first.name,
                    subtitle: l10n.dashboardLastUpdatedShort(l10n.dashboardSampleUpdatedTime),
                    initials: _initialsFor(selectedAgency?.name ?? agencies.first.name),
                    onTap: () => _openAgencyPicker(context, agenciesController),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.center_focus_strong),
                    label: Text(l10n.dashboardScanDocument),
                    onPressed: () => context.push('/scan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B6AF6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...kpis.map((card) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _KpiCard(data: card),
                    )),
                const SizedBox(height: 4),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _QuickActionTile(
                      icon: Icons.download_for_offline_outlined,
                      label: l10n.dashboardExportReport,
                      onTap: () => context.push('/reports'),
                    ),
                    _QuickActionTile(
                      icon: Icons.add_circle_outline,
                      label: l10n.dashboardAddManual,
                      onTap: () => context.push('/manual-entry'),
                    ),
                    _QuickActionTile(
                      icon: Icons.help_outline,
                      label: l10n.dashboardHelp,
                      onTap: () => context.push('/help'),
                    ),
                    _QuickActionTile(
                      icon: Icons.groups_outlined,
                      label: l10n.dashboardManageAgency,
                      onTap: () => context.push('/agencies'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SectionHeader(
                  title: l10n.dashboardRecentOperations,
                  actionLabel: l10n.dashboardViewAll,
                  onTap: () => context.push('/transactions'),
                ),
                const SizedBox(height: 8),
                _RecentTableHeader(
                  documentLabel: l10n.dashboardColumnDocument,
                  typeLabel: l10n.dashboardColumnType,
                  dateLabel: l10n.dashboardColumnDate,
                  numberLabel: l10n.dashboardColumnNumber,
                ),
                const SizedBox(height: 8),
                if (recent.isEmpty)
                  _EmptyInline(label: l10n.dashboardNoRecentEntries)
                else
                  ...recent.take(5).map(
                        (item) => _RecentTransactionTile(
                          item: _RecentTransaction(
                            documentNumber: item.invoiceNumber ?? '-',
                            typeLabel: _typeLabel(item.type, l10n),
                            dateLabel: '${dateFormatter.format(item.date)} ${timeFormatter.format(item.date)}',
                            icon: _typeIcon(item.type),
                            iconColor: _typeColor(item.type),
                          ),
                        ),
                      ),
              ],
            ),
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

  IconData _typeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.purchaseCredit:
        return Icons.shopping_cart_outlined;
      case TransactionType.payment:
        return Icons.payments_outlined;
      case TransactionType.returnTxn:
        return Icons.autorenew;
      case TransactionType.openingBalance:
        return Icons.account_balance_wallet_outlined;
      case TransactionType.purchaseCash:
        return Icons.point_of_sale_outlined;
      case TransactionType.compensation:
        return Icons.card_giftcard;
    }
  }

  Color _typeColor(TransactionType type) {
    switch (type) {
      case TransactionType.purchaseCredit:
        return const Color(0xFFFB923C);
      case TransactionType.payment:
        return const Color(0xFF16A34A);
      case TransactionType.returnTxn:
        return const Color(0xFF8B5CF6);
      case TransactionType.openingBalance:
        return const Color(0xFF4C78FF);
      case TransactionType.purchaseCash:
        return const Color(0xFF0EA5E9);
      case TransactionType.compensation:
        return const Color(0xFFF59E0B);
    }
  }

  String _initialsFor(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '--';
    }
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return '--';
    }
    if (parts.length == 1) {
      final first = parts.first;
      final len = first.length >= 2 ? 2 : 1;
      return first.substring(0, len).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  void _openAgencyPicker(BuildContext context, AgenciesController controller) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.dashboardSelectAgency,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...controller.agencies.map(
                (agency) => ListTile(
                  title: Text(agency.name),
                  trailing: agency.id == controller.selectedAgencyId
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    controller.selectAgency(agency.id);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: Text(l10n.agenciesCreate),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/agencies');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Totals {
  const _Totals({
    required this.netBalance,
    required this.purchasesCredit,
    required this.returnsAmount,
    required this.payments,
    required this.trendLabel,
    required this.trendColor,
  });

  final num netBalance;
  final num purchasesCredit;
  final num returnsAmount;
  final num payments;
  final String? trendLabel;
  final Color? trendColor;

  static _Totals fromTransactions({
    required List<Transaction> transactions,
    required num openingBalance,
  }) {
    num purchasesCredit = 0;
    num returnsAmount = 0;
    num payments = 0;

    for (final txn in transactions) {
      if (txn.status != TransactionStatus.posted) {
        continue;
      }
      switch (txn.type) {
        case TransactionType.purchaseCredit:
          purchasesCredit += txn.amountInBase;
          break;
        case TransactionType.returnTxn:
          returnsAmount += txn.amountInBase;
          break;
        case TransactionType.payment:
          payments += txn.amountInBase;
          break;
        case TransactionType.openingBalance:
        case TransactionType.purchaseCash:
        case TransactionType.compensation:
          break;
      }
    }

    final netBalance = openingBalance - purchasesCredit + returnsAmount + payments;
    final trendLabel = netBalance >= 0 ? '+${netBalance.toStringAsFixed(0)}' : netBalance.toStringAsFixed(0);
    final trendColor = netBalance >= 0 ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return _Totals(
      netBalance: netBalance,
      purchasesCredit: purchasesCredit,
      returnsAmount: returnsAmount,
      payments: payments,
      trendLabel: trendLabel,
      trendColor: trendColor,
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: Text(l10n.drawerDashboard),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.center_focus_strong),
              title: Text(l10n.drawerScan),
              onTap: () => _openRoute(context, '/scan'),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text(l10n.drawerManualEntry),
              onTap: () => _openRoute(context, '/manual-entry'),
            ),
            ListTile(
              leading: const Icon(Icons.download_for_offline_outlined),
              title: Text(l10n.drawerReports),
              onTap: () => _openRoute(context, '/reports'),
            ),
            ListTile(
              leading: const Icon(Icons.apartment_outlined),
              title: Text(l10n.drawerAgencies),
              onTap: () => _openRoute(context, '/agencies'),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(l10n.drawerHelp),
              onTap: () => _openRoute(context, '/help'),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.drawerSettings),
              onTap: () => _openRoute(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _openRoute(BuildContext context, String route) {
    Navigator.pop(context);
    context.push(route);
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onMenuTap});

  final String title;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onMenuTap,
          icon: const Icon(Icons.menu),
        ),
        const Spacer(),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const Spacer(),
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFE5ECFF),
          child: Text(
            'SA',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF3B6AF6),
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}

class _AgencyCard extends StatelessWidget {
  const _AgencyCard({
    required this.title,
    required this.agencyName,
    required this.subtitle,
    required this.initials,
    required this.onTap,
  });

  final String title;
  final String agencyName;
  final String subtitle;
  final String initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            agencyName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE7F0FF),
                child: Text(
                  initials,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF3B6AF6),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgencyEmptyCard extends StatelessWidget {
  const _AgencyEmptyCard({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyInline extends StatelessWidget {
  const _EmptyInline({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(label),
      ),
    );
  }
}

class _KpiCardData {
  const _KpiCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    this.trendLabel,
    this.trendColor,
    this.helperLabel,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String? trendLabel;
  final Color? trendColor;
  final String? helperLabel;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.data});

  final _KpiCardData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (data.trendLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (data.trendColor ?? Colors.green).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            data.trendLabel!,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: data.trendColor ?? Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      if (data.helperLabel != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          data.helperLabel!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: data.iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(data.icon, color: data.iconColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFF1F5FF),
                child: Icon(icon, color: const Color(0xFF3B6AF6)),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.arrow_back, size: 16),
          label: Text(actionLabel),
        ),
      ],
    );
  }
}

class _RecentTableHeader extends StatelessWidget {
  const _RecentTableHeader({
    required this.documentLabel,
    required this.typeLabel,
    required this.dateLabel,
    required this.numberLabel,
  });

  final String documentLabel;
  final String typeLabel;
  final String dateLabel;
  final String numberLabel;

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
          Expanded(
            flex: 3,
            child: Text(
              documentLabel,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              typeLabel,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              dateLabel,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              numberLabel,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTransaction {
  const _RecentTransaction({
    required this.documentNumber,
    required this.typeLabel,
    required this.dateLabel,
    required this.icon,
    required this.iconColor,
  });

  final String documentNumber;
  final String typeLabel;
  final String dateLabel;
  final IconData icon;
  final Color iconColor;
}

class _RecentTransactionTile extends StatelessWidget {
  const _RecentTransactionTile({required this.item});

  final _RecentTransaction item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                item.documentNumber,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: item.iconColor.withOpacity(0.12),
                    child: Icon(item.icon, color: item.iconColor, size: 14),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.typeLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                item.dateLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFF2F4F8),
                  child: Icon(Icons.image_outlined, color: Colors.grey.shade700, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
