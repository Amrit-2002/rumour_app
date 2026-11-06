import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime createdAt;
  final bool isPending;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.createdAt,
    this.isPending = false,
  });

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final rawTimestamp = data['createdAt'];

    DateTime resolvedDate;
    if (rawTimestamp is Timestamp) {
      resolvedDate = rawTimestamp.toDate();
    } else {
      // Local optimistic fallback while pending server sync
      resolvedDate = DateTime.now();
    }

    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? 'Anonymous',
      text: data['text'] as String? ?? '',
      createdAt: resolvedDate,
      isPending: doc.metadata.hasPendingWrites,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

