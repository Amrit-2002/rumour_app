import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/main.dart';

void main() {
  testWidgets('RumourApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RumourApp());
    expect(find.text('Rumour - Initializing'), findsOneWidget);
  });
}
