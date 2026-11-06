import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  final String roomCode;
  final DateTime createdAt;
  final String createdBy;
  final int memberCount;
  final bool isActive;

  const RoomModel({
    required this.roomCode,
    required this.createdAt,
    required this.createdBy,
    this.memberCount = 1,
    this.isActive = true,
  });

  factory RoomModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    final rawCreatedAt = data['createdAt'];

    DateTime resolvedDate;
    if (rawCreatedAt is Timestamp) {
      resolvedDate = rawCreatedAt.toDate();
    } else {
      resolvedDate = DateTime.now();
    }

    return RoomModel(
      roomCode: data['roomCode'] ?? snapshot.id,
      createdAt: resolvedDate,
      createdBy: data['createdBy'] ?? '',
      memberCount: (data['memberCount'] as num?)?.toInt() ?? 1,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomCode': roomCode,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'memberCount': memberCount,
      'isActive': isActive,
    };
  }
}

