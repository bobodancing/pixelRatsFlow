import 'package:flutter/material.dart';
import 'package:pixelrats/l10n/app_localizations.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        foregroundColor: AppColors.textCream,
        title: Text(l10n.settingsButton),
      ),
      body: Center(
        child: Text(l10n.placeholderScreen, style: AppTypography.subtitle),
      ),
    );
  }
}
