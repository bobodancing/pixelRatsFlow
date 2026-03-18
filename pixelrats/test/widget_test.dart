// PixelRats smoke test — verifies the app boots without crashing.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelrats/app.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PixelRatsApp()),
    );
    // If no exception is thrown, the smoke test passes.
  });
}
