import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pixelrats/l10n/app_localizations.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

class PixelRatsApp extends StatelessWidget {
  const PixelRatsApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      locale: const Locale('zh', 'TW'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('zh', 'TW')],
      home: const HomeScreen(),
    );
  }
}
