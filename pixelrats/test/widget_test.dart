// PixelRats smoke test — verifies core widgets render without crashing.
// Note: PixelRatsApp requires Firebase initialization, so we test
// individual screens with mock data instead.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pixelrats/l10n/app_localizations.dart';
import 'package:pixelrats/screens/home_screen.dart';
import 'package:pixelrats/utils/app_theme.dart';

void main() {
  testWidgets('HomeScreen renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
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
        ),
      ),
    );
    await tester.pump();
    // If no exception is thrown, the smoke test passes.
  });
}
