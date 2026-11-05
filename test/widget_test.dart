import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/app.dart';

void main() {
  testWidgets('RumourApp initializes with dark theme and initial route', (WidgetTester tester) async {
    await tester.pumpWidget(const RumourApp());
    expect(find.text('Join Room (Placeholder)'), findsOneWidget);
  });
}
