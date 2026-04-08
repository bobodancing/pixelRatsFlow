import 'package:flutter/material.dart';
import 'package:pixelrats/l10n/app_localizations.dart';
import '../utils/app_theme.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('PixelRats', style: AppTypography.splashTitle),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              style: AppButtonStyles.primary,
              icon: const Icon(Icons.login),
              label: Text(l10n.signInWithGoogle),
              onPressed: onSignIn,
            ),
          ],
        ),
      ),
    );
  }
}
