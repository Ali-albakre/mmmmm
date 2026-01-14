import 'package:flutter/material.dart';
import 'package:mmmmm/app/di.dart';
import 'package:mmmmm/features/agencies/domain/entities/agency.dart';
import 'package:mmmmm/features/agencies/presentation/controllers/agencies_controller.dart';
import 'package:mmmmm/features/settings/domain/entities/app_settings.dart';
import 'package:mmmmm/features/settings/presentation/controllers/settings_controller.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

class AgenciesScreen extends StatelessWidget {
  const AgenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AgenciesController>();
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context)!;
        final agencies = controller.agencies;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.agenciesTitle),
            actions: [
              IconButton(
                onPressed: () => _openCreateAgency(context, controller),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: SafeArea(
            child: agencies.isEmpty
                ? _EmptyState(
                    icon: Icons.apartment_outlined,
                    message: l10n.agenciesEmpty,
                    actionLabel: l10n.agenciesCreate,
                    onAction: () => _openCreateAgency(context, controller),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final agency = agencies[index];
                      final isSelected = agency.id == controller.selectedAgencyId;
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          title: Text(agency.name),
                          subtitle: Text(l10n.agenciesOpeningBalance(agency.openingBalance)),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          onTap: () => controller.selectAgency(agency.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: agencies.length,
                  ),
          ),
        );
      },
    );
  }

  Future<void> _openCreateAgency(
    BuildContext context,
    AgenciesController controller,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final balanceController = TextEditingController();
    final openingDateController = TextEditingController();
    var openingDate = DateTime(DateTime.now().year, 1, 1);
    final settings = getIt<SettingsController>().settings;
    var primaryCurrency = settings.currency;
    final allowedCurrencies = <CurrencyCode>{CurrencyCode.yer, CurrencyCode.sar};
    openingDateController.text =
        MaterialLocalizations.of(context).formatFullDate(openingDate);
    final result = await showModalBottomSheet<Agency>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.agenciesCreate, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: l10n.agenciesName),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: balanceController,
                    keyboardType: const TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(labelText: l10n.agenciesOpeningBalanceLabel),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<CurrencyCode>(
                    initialValue: primaryCurrency,
                    decoration: InputDecoration(labelText: l10n.agenciesPrimaryCurrency),
                    items: [
                      DropdownMenuItem(
                        value: CurrencyCode.yer,
                        child: Text(l10n.currencyYER),
                      ),
                      DropdownMenuItem(
                        value: CurrencyCode.sar,
                        child: Text(l10n.currencySAR),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        primaryCurrency = value;
                        allowedCurrencies.add(value);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.agenciesAllowedCurrencies,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  CheckboxListTile(
                    value: allowedCurrencies.contains(CurrencyCode.yer),
                    title: Text(l10n.currencyYER),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          allowedCurrencies.add(CurrencyCode.yer);
                        } else {
                          allowedCurrencies.remove(CurrencyCode.yer);
                          if (primaryCurrency == CurrencyCode.yer) {
                            allowedCurrencies.add(CurrencyCode.yer);
                          }
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: allowedCurrencies.contains(CurrencyCode.sar),
                    title: Text(l10n.currencySAR),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          allowedCurrencies.add(CurrencyCode.sar);
                        } else {
                          allowedCurrencies.remove(CurrencyCode.sar);
                          if (primaryCurrency == CurrencyCode.sar) {
                            allowedCurrencies.add(CurrencyCode.sar);
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: openingDateController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: l10n.agenciesOpeningBalanceDate),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: openingDate,
                        firstDate: DateTime(DateTime.now().year - 3, 1, 1),
                        lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                      );
                      if (picked == null) {
                        return;
                      }
                      setState(() {
                        openingDate = picked;
                        openingDateController.text =
                            MaterialLocalizations.of(context).formatFullDate(picked);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isEmpty) {
                          return;
                        }
                        if (!(openingDate.month == 1 && openingDate.day == 1)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.agenciesOpeningBalanceDateInvalid)),
                          );
                          return;
                        }
                        final balance = num.tryParse(balanceController.text.trim()) ?? 0;
                        Navigator.pop(
                          context,
                          Agency(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: name,
                            openingBalance: balance,
                            openingBalanceDate: openingDate,
                            primaryCurrency: primaryCurrency,
                            allowedCurrencies: allowedCurrencies.toList(),
                            createdAt: DateTime.now(),
                          ),
                        );
                      },
                      child: Text(l10n.agenciesSave),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      await controller.addAgency(result);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
