import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmmmm/app/di.dart';
import 'package:mmmmm/features/settings/domain/entities/app_settings.dart';
import 'package:mmmmm/features/settings/presentation/controllers/settings_controller.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late AppSettings _draft;
  final SettingsController _settingsController = getIt<SettingsController>();

  @override
  void initState() {
    super.initState();
    _draft = _settingsController.settings;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.onboardingTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.onboardingSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: l10n.chooseLanguage),
            RadioListTile<AppLocale>(
              value: AppLocale.ar,
              groupValue: _draft.locale,
              title: Text(l10n.languageArabic),
              onChanged: (value) => _updateDraft(locale: value),
            ),
            RadioListTile<AppLocale>(
              value: AppLocale.en,
              groupValue: _draft.locale,
              title: Text(l10n.languageEnglish),
              onChanged: (value) => _updateDraft(locale: value),
            ),
            const SizedBox(height: 16),
            _SectionTitle(title: l10n.chooseCurrency),
            RadioListTile<CurrencyCode>(
              value: CurrencyCode.yer,
              groupValue: _draft.currency,
              title: Text(l10n.currencyYER),
              onChanged: (value) => _updateDraft(currency: value),
            ),
            RadioListTile<CurrencyCode>(
              value: CurrencyCode.sar,
              groupValue: _draft.currency,
              title: Text(l10n.currencySAR),
              onChanged: (value) => _updateDraft(currency: value),
            ),
            const SizedBox(height: 16),
            _SectionTitle(title: l10n.chooseInventoryMode),
            RadioListTile<InventoryMode>(
              value: InventoryMode.simple,
              groupValue: _draft.inventoryMode,
              title: Text(l10n.inventorySimple),
              onChanged: (value) => _updateDraft(inventoryMode: value),
            ),
            RadioListTile<InventoryMode>(
              value: InventoryMode.full,
              groupValue: _draft.inventoryMode,
              title: Text(l10n.inventoryFull),
              onChanged: (value) => _updateDraft(inventoryMode: value),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(l10n.continueLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDraft({
    AppLocale? locale,
    CurrencyCode? currency,
    InventoryMode? inventoryMode,
  }) {
    setState(() {
      _draft = _draft.copyWith(
        locale: locale ?? _draft.locale,
        currency: currency ?? _draft.currency,
        inventoryMode: inventoryMode ?? _draft.inventoryMode,
      );
    });
  }

  Future<void> _submit() async {
    await _settingsController.save(_draft);
    if (mounted) {
      context.go('/dashboard');
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
