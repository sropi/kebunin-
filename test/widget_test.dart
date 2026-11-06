import 'package:flutter_test/flutter_test.dart';
import 'package:kebunin/app/app.dart';

void main() {
  testWidgets('KEBUNIN App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KebuninApp());
    expect(find.byType(KebuninApp), findsOneWidget);

    // Settle splash timers
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
