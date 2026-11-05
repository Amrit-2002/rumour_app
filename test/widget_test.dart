import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/app.dart';

void main() {
  testWidgets('Full UI mock navigation walkthrough: Join -> Reveal -> Chat', (WidgetTester tester) async {
    // 1. Build RumourApp and trigger a frame.
    await tester.pumpWidget(const RumourApp());
    await tester.pumpAndSettle();

    // Verify Join Room screen elements
    expect(find.text('Rumour'), findsOneWidget);
    expect(find.text('Join Room'), findsOneWidget);
    expect(find.text('Create New Room'), findsOneWidget);

    // Enter a 6-digit room code
    final inputFinder = find.byType(TextField);
    expect(inputFinder, findsOneWidget);
    await tester.enterText(inputFinder, 'ABC123');
    await tester.pump();

    // Tap Join Room button
    final joinButtonFinder = find.widgetWithText(ElevatedButton, 'Join Room');
    expect(joinButtonFinder, findsOneWidget);
    await tester.tap(joinButtonFinder);
    await tester.pumpAndSettle();

    // 2. Verify Identity Reveal screen
    expect(find.text('YOU ARE JOINING AS'), findsOneWidget);
    expect(find.text('Neon Falcon'), findsOneWidget);
    expect(find.text('Room #ABC123'), findsOneWidget);
    expect(find.text('Enter Chat Room'), findsOneWidget);

    // Tap Enter Chat Room
    final enterChatFinder = find.widgetWithText(ElevatedButton, 'Enter Chat Room');
    await tester.tap(enterChatFinder);
    await tester.pumpAndSettle();

    // 3. Verify Group Chat screen
    expect(find.text('Room #ABC123'), findsOneWidget);
    expect(find.text('as Neon Falcon'), findsOneWidget);
    expect(find.text('Type a rumour...'), findsOneWidget);

    // Send a new message
    final chatInputFinder = find.widgetWithText(TextField, 'Type a rumour...');
    await tester.enterText(chatInputFinder, 'Hello from widget test!');
    await tester.pump();

    final sendButtonFinder = find.byIcon(Icons.arrow_upward_rounded);
    expect(sendButtonFinder, findsOneWidget);
    await tester.tap(sendButtonFinder);
    await tester.pumpAndSettle();

    // Verify message was appended to feed
    expect(find.text('Hello from widget test!'), findsOneWidget);
  });
}
