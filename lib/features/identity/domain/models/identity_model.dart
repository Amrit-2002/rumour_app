import 'dart:convert';

class IdentityModel {
  final String adjective;
  final String animal;
  final String roomCode;
  final String uid;
  final DateTime assignedAt;
  final bool isRestored;

  const IdentityModel({
    required this.adjective,
    required this.animal,
    required this.roomCode,
    required this.uid,
    required this.assignedAt,
    this.isRestored = false,
  });

  String get fullName => '$adjective $animal';
  String get firstName => adjective;
  String get lastName => animal;

  IdentityModel copyWith({
    String? adjective,
    String? animal,
    String? roomCode,
    String? uid,
    DateTime? assignedAt,
    bool? isRestored,
  }) {
    return IdentityModel(
      adjective: adjective ?? this.adjective,
      animal: animal ?? this.animal,
      roomCode: roomCode ?? this.roomCode,
      uid: uid ?? this.uid,
      assignedAt: assignedAt ?? this.assignedAt,
      isRestored: isRestored ?? this.isRestored,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adjective': adjective,
      'animal': animal,
      'roomCode': roomCode,
      'uid': uid,
      'assignedAt': assignedAt.toIso8601String(),
    };
  }

  factory IdentityModel.fromMap(
    Map<String, dynamic> map, {
    bool isRestored = true,
  }) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(map['assignedAt'] as String);
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return IdentityModel(
      adjective: map['adjective'] as String? ?? 'Brave',
      animal: map['animal'] as String? ?? 'Badger',
      roomCode: map['roomCode'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
      assignedAt: parsedDate,
      isRestored: isRestored,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory IdentityModel.fromJson(
    String source, {
    bool isRestored = true,
  }) {
    return IdentityModel.fromMap(
      jsonDecode(source) as Map<String, dynamic>,
      isRestored: isRestored,
    );
  }
}

