import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:rumour/features/chat/presentation/widgets/offline_banner.dart';

void main() {
  group('Offline & Sync Indicators', () {
    testWidgets('OfflineBanner renders expected offline message and icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OfflineBanner(),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      expect(find.text('Offline mode — messages will sync when reconnected'),
          findsOneWidget);
    });

    testWidgets('ChatBubble with isPending: true displays schedule/clock icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              text: 'Unsynced offline message',
              senderName: 'Brave Badger',
              time: '10:15',
              isMe: true,
              isPending: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
      expect(find.byIcon(Icons.done_all_rounded), findsNothing);
    });

    testWidgets('ChatBubble with isPending: false displays done_all checkmark icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              text: 'Synced message',
              senderName: 'Brave Badger',
              time: '10:16',
              isMe: true,
              isPending: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.done_all_rounded), findsOneWidget);
      expect(find.byIcon(Icons.schedule_rounded), findsNothing);
    });
  });
}

