import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/app.dart';

void main() {
  testWidgets('Exact Figma UI flow: Join A Room -> Reveal (Brave Badger) -> Chat', (WidgetTester tester) async {
    // 1. Build RumourApp and trigger frame
    await tester.pumpWidget(const RumourApp());
    await tester.pumpAndSettle();

    // Verify Join A Room screen elements
    expect(find.text('Join A Room'), findsOneWidget);
    expect(find.text('Enter the code to join the anon chat room'), findsOneWidget);
    expect(find.text('Join Room'), findsOneWidget);
    expect(find.text('Create New Room'), findsOneWidget);

    // Enter a 6-digit room code
    final inputFinder = find.byType(TextField);
    expect(inputFinder, findsOneWidget);
    await tester.enterText(inputFinder, '581290');
    await tester.pumpAndSettle();

    // Tap Join Room
    final joinButtonFinder = find.widgetWithText(ElevatedButton, 'Join Room');
    expect(joinButtonFinder, findsOneWidget);
    await tester.tap(joinButtonFinder);
    await tester.pumpAndSettle();

    // 2. Verify Identity Reveal screen (matching Figma)
    expect(find.text('For this room, you are'), findsOneWidget);
    expect(find.text('Brave\nBadger'), findsOneWidget);
    expect(find.text('Room #581290'), findsOneWidget);
    expect(find.text('1 members'), findsOneWidget);
    expect(find.text('Acknowledge and continue'), findsOneWidget);

    // Tap Acknowledge and continue
    final acknowledgeFinder = find.widgetWithText(ElevatedButton, 'Acknowledge and continue');
    await tester.tap(acknowledgeFinder);
    await tester.pumpAndSettle();

    // 3. Verify Group Chat screen (matching Figma)
    expect(find.text('Room #581290'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Type a message...'), findsOneWidget);
    expect(find.text('Hi all! I came to visit your city for the weekend. Suggest coffee shop for breakfast with family.'), findsOneWidget);

    // Send a message
    final chatInputFinder = find.widgetWithText(TextField, 'Type a message...');
    await tester.enterText(chatInputFinder, 'Figma pixel fidelity verified!');
    await tester.pumpAndSettle();

    final sendButtonFinder = find.byIcon(Icons.near_me_rounded);
    expect(sendButtonFinder, findsOneWidget);
    await tester.tap(sendButtonFinder);
    await tester.pumpAndSettle();

    // Verify message was appended to feed
    expect(find.text('Figma pixel fidelity verified!'), findsOneWidget);
  });
}
