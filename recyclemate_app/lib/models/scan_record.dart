import 'package:cloud_firestore/cloud_firestore.dart';

class ScanRecord {
  final String id;
  final String userId;
  final String code;
  final String materialType;
  final double weightKg;
  final int points;
  final String instructions;
  final DateTime createdAt;

  ScanRecord({
    required this.id,
    required this.userId,
    required this.code,
    required this.materialType,
    required this.weightKg,
    required this.points,
    required this.instructions,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'code': code,
      'materialType': materialType,
      'weightKg': weightKg,
      'points': points,
      'instructions': instructions,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ScanRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScanRecord(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      code: data['code'] as String? ?? '',
      materialType: data['materialType'] as String? ?? 'unknown',
      weightKg: (data['weightKg'] as num?)?.toDouble() ?? 0,
      points: (data['points'] as num?)?.toInt() ?? 0,
      instructions: data['instructions'] as String? ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  ScanRecord copyWith({
    String? id,
    String? userId,
    String? code,
    String? materialType,
    double? weightKg,
    int? points,
    String? instructions,
    DateTime? createdAt,
  }) {
    return ScanRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      code: code ?? this.code,
      materialType: materialType ?? this.materialType,
      weightKg: weightKg ?? this.weightKg,
      points: points ?? this.points,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
