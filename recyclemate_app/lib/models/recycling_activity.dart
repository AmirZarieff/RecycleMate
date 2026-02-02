import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class for Recycling Activity
/// Represents a single recycling activity logged by a user
class RecyclingActivity {
  final String id;
  final String userId;
  final String materialType;
  final double weight; // in KG
  final int points;
  final DateTime date;
  final String? notes;
  final String status; // 'completed', 'pending', 'cancelled'

  RecyclingActivity({
    required this.id,
    required this.userId,
    required this.materialType,
    required this.weight,
    required this.points,
    required this.date,
    this.notes,
    this.status = 'completed',
  });

  /// Convert RecyclingActivity to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'materialType': materialType,
      'weight': weight,
      'points': points,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'status': status,
    };
  }

  /// Create RecyclingActivity from Firestore document
  factory RecyclingActivity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RecyclingActivity(
      id: doc.id,
      userId: data['userId'] ?? '',
      materialType: data['materialType'] ?? '',
      weight: (data['weight'] ?? 0).toDouble(),
      points: data['points'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes'],
      status: data['status'] ?? 'completed',
    );
  }

  /// Create a copy of RecyclingActivity with modified fields
  RecyclingActivity copyWith({
    String? id,
    String? userId,
    String? materialType,
    double? weight,
    int? points,
    DateTime? date,
    String? notes,
    String? status,
  }) {
    return RecyclingActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      materialType: materialType ?? this.materialType,
      weight: weight ?? this.weight,
      points: points ?? this.points,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }

  /// Calculate points based on material type and weight
  static int calculatePoints(String materialType, double weight) {
    final pointsPerKg = {
      'Plastic': 10,
      'Glass': 10,
      'Paper': 10,
      'Cans': 10,
      'E-Waste': 25,
      'Clothes': 8,
    };
    return ((pointsPerKg[materialType] ?? 10) * weight).round();
  }
}
