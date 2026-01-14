import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mmmmm/app/di.dart';
import 'package:mmmmm/features/settings/domain/entities/app_settings.dart';
import 'package:mmmmm/features/settings/presentation/controllers/settings_controller.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = getIt<SettingsController>().settings;
    final localeTag = settings.locale == AppLocale.ar ? 'ar' : 'en';
    final currencyCode = settings.currency == CurrencyCode.yer ? 'YER' : 'SAR';
    final currencyFormatter = NumberFormat.currency(
      locale: localeTag,
      name: currencyCode,
      symbol: currencyCode,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              runSpacing: 16,
              spacing: 16,
              children: [
                _SummaryCard(
                  title: l10n.dashboardSales,
                  value: currencyFormatter.format(0),
                  icon: Icons.point_of_sale,
                ),
                _SummaryCard(
                  title: l10n.dashboardPurchases,
                  value: currencyFormatter.format(0),
                  icon: Icons.local_shipping,
                ),
                _SummaryCard(
                  title: l10n.dashboardExpenses,
                  value: currencyFormatter.format(0),
                  icon: Icons.receipt_long,
                ),
                _SummaryCard(
                  title: l10n.dashboardExpiryAlerts,
                  value: '0',
                  icon: Icons.warning_amber,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.emptyStateNoData,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    return SizedBox(
      width: cardWidth > 240 ? 240 : cardWidth,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
