import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/features/room/presentation/screens/join_room_screen.dart';

void main() {
  group('JoinRoomScreen Widget Tests', () {
    testWidgets('Renders all Figma brand elements and input field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: JoinRoomScreen(),
        ),
      );

      expect(find.byIcon(Icons.key_rounded), findsOneWidget);
      expect(find.text('Join A Room'), findsOneWidget);
      expect(find.text('Enter the code to join the anon chat room'),
          findsOneWidget);
      expect(find.text('Join Room'), findsOneWidget);
      expect(find.text('Create New Room'), findsOneWidget);
    });

    testWidgets('Join Room button is disabled initially and enables on 6 chars',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: JoinRoomScreen(),
        ),
      );

      final joinButtonFinder = find.widgetWithText(ElevatedButton, 'Join Room');
      final ElevatedButton initialButton = tester.widget(joinButtonFinder);
      expect(initialButton.onPressed, isNull); // disabled

      // Enter 4 characters
      final inputFinder = find.byType(TextField);
      await tester.enterText(inputFinder, 'ABCD');
      await tester.pump();

      final ElevatedButton buttonAfter4 = tester.widget(joinButtonFinder);
      expect(buttonAfter4.onPressed, isNull); // still disabled

      // Enter 6 characters
      await tester.enterText(inputFinder, 'ABCDEF');
      await tester.pump();

      final ElevatedButton buttonAfter6 = tester.widget(joinButtonFinder);
      expect(buttonAfter6.onPressed, isNotNull); // enabled!
    });
  });
}

