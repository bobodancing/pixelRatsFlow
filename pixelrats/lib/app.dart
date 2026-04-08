import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelrats/l10n/app_localizations.dart';
import 'repositories/auth_repository.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';

class PixelRatsApp extends ConsumerWidget {
  const PixelRatsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);

    return MaterialApp(
      title: 'PixelRats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.purple,
          surface: AppColors.bgPrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('zh', 'TW')],
      home: StreamBuilder<AuthUser?>(
        stream: authRepo.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: AppColors.bgDark,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.purple),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          }
          return SignInScreen(onSignIn: () => authRepo.signInWithGoogle());
        },
      ),
    );
  }
}
