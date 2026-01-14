import 'package:flutter/material.dart';
import 'package:mmmmm/app/di.dart';
import 'package:mmmmm/features/backup/presentation/controllers/backup_controller.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = getIt<BackupController>();
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final settings = controller.settings;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settingsTitle),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.settingsBackupTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                value: settings.driveBackupEnabled,
                title: Text(l10n.settingsDriveBackupToggle),
                subtitle: Text(l10n.settingsDriveBackupHint),
                onChanged: (value) => controller.enableDriveBackup(value),
              ),
              const SizedBox(height: 8),
              if (settings.driveAccountEmail != null)
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(settings.driveAccountEmail!),
                  subtitle: Text(l10n.settingsDriveAccountConnected),
                  trailing: TextButton(
                    onPressed: () => controller.enableDriveBackup(false),
                    child: Text(l10n.settingsDisconnect),
                  ),
                )
              else
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(l10n.settingsDriveAccountTitle),
                  subtitle: Text(l10n.settingsDriveAccountSubtitle),
                  trailing: TextButton(
                    onPressed: () => controller.enableDriveBackup(true),
                    child: Text(l10n.settingsConnect),
                  ),
                ),
              const SizedBox(height: 8),
              if (settings.lastDriveBackup != null)
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.settingsLastBackup),
                  subtitle: Text(
                    MaterialLocalizations.of(context)
                        .formatFullDate(settings.lastDriveBackup!),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isBackingUp ? null : controller.backupNow,
                  icon: const Icon(Icons.backup_outlined),
                  label: Text(
                    controller.isBackingUp
                        ? l10n.settingsBackupInProgress
                        : l10n.settingsBackupNow,
                  ),
                ),
              ),
              if (controller.lastError != null) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.settingsBackupFailed(controller.lastError!),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
