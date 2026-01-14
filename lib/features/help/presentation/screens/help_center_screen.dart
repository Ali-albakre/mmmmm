import 'package:flutter/material.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _HelpItem(title: l10n.helpAccuracyTitle, body: l10n.helpAccuracyBody),
      _HelpItem(title: l10n.helpCorrectionsTitle, body: l10n.helpCorrectionsBody),
      _HelpItem(title: l10n.helpDuplicatesTitle, body: l10n.helpDuplicatesBody),
      _HelpItem(title: l10n.helpReportsTitle, body: l10n.helpReportsBody),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpTitle),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            elevation: 0,
            child: ExpansionTile(
              title: Text(item.title),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Text(item.body),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: items.length,
      ),
    );
  }
}

class _HelpItem {
  const _HelpItem({required this.title, required this.body});

  final String title;
  final String body;
}
