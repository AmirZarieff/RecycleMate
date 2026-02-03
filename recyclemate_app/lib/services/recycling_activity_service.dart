import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recycling_activity.dart';

/// Service class to handle Firestore operations for Recycling Activities
/// This class provides CRUD (Create, Read, Update, Delete) operations
class RecyclingActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'recycling_activities';

  /// Get reference to the recycling activities collection
  CollectionReference get _collection =>
      _firestore.collection(collectionName);

  /// CREATE: Add a new recycling activity
  Future<String> addActivity(RecyclingActivity activity) async {
    try {
      DocumentReference docRef = await _collection.add(activity.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add activity: $e');
    }
  }

  /// READ: Get all activities for a specific user
  Stream<List<RecyclingActivity>> getUserActivities(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RecyclingActivity.fromFirestore(doc))
          .toList();
    });
  }

  /// READ: Get activities for a specific date range
  Stream<List<RecyclingActivity>> getActivitiesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _collection
        .where('userId', isEqualTo: userId)
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RecyclingActivity.fromFirestore(doc))
          .toList();
    });
  }

  /// READ: Get a single activity by ID
  Future<RecyclingActivity?> getActivityById(String activityId) async {
    try {
      DocumentSnapshot doc = await _collection.doc(activityId).get();
      if (doc.exists) {
        return RecyclingActivity.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get activity: $e');
    }
  }

  /// UPDATE: Update an existing activity
  Future<void> updateActivity(RecyclingActivity activity) async {
    try {
      await _collection.doc(activity.id).update(activity.toMap());
    } catch (e) {
      throw Exception('Failed to update activity: $e');
    }
  }

  /// DELETE: Delete an activity
  Future<void> deleteActivity(String activityId) async {
    try {
      await _collection.doc(activityId).delete();
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }

  /// Get weekly summary (current week from Sunday to Saturday)
  Future<Map<String, dynamic>> getWeeklySummary(String userId) async {
    DateTime now = DateTime.now();
    
    // Calculate the start of the week (Sunday)
    int daysFromSunday = now.weekday % 7; // Sunday = 0, Monday = 1, ..., Saturday = 6
    DateTime startDate = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysFromSunday));
    
    // Calculate the end of the week (Saturday)
    DateTime endDate = startDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    QuerySnapshot snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    double totalWeight = 0;
    int totalPoints = 0;
    Map<String, double> materialBreakdown = {};

    for (var doc in snapshot.docs) {
      RecyclingActivity activity = RecyclingActivity.fromFirestore(doc);
      totalWeight += activity.weight;
      totalPoints += activity.points;

      materialBreakdown[activity.materialType] =
          (materialBreakdown[activity.materialType] ?? 0) + activity.weight;
    }

    return {
      'totalWeight': totalWeight,
      'totalPoints': totalPoints,
      'totalActivities': snapshot.docs.length,
      'materialBreakdown': materialBreakdown,
      'period': 'weekly',
    };
  }

  /// Get monthly summary (current calendar month)
  Future<Map<String, dynamic>> getMonthlySummary(String userId) async {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1, hours: -23, minutes: -59, seconds: -59));

    QuerySnapshot snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    double totalWeight = 0;
    int totalPoints = 0;
    Map<String, double> materialBreakdown = {};

    for (var doc in snapshot.docs) {
      RecyclingActivity activity = RecyclingActivity.fromFirestore(doc);
      totalWeight += activity.weight;
      totalPoints += activity.points;

      materialBreakdown[activity.materialType] =
          (materialBreakdown[activity.materialType] ?? 0) + activity.weight;
    }

    return {
      'totalWeight': totalWeight,
      'totalPoints': totalPoints,
      'totalActivities': snapshot.docs.length,
      'materialBreakdown': materialBreakdown,
      'period': 'monthly',
    };
  }

  /// Get all-time summary for a user
  Future<Map<String, dynamic>> getAllTimeSummary(String userId) async {
    QuerySnapshot snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .get();

    double totalWeight = 0;
    int totalPoints = 0;
    Map<String, double> materialBreakdown = {};

    for (var doc in snapshot.docs) {
      RecyclingActivity activity = RecyclingActivity.fromFirestore(doc);
      totalWeight += activity.weight;
      totalPoints += activity.points;

      materialBreakdown[activity.materialType] =
          (materialBreakdown[activity.materialType] ?? 0) + activity.weight;
    }

    return {
      'totalWeight': totalWeight,
      'totalPoints': totalPoints,
      'totalActivities': snapshot.docs.length,
      'materialBreakdown': materialBreakdown,
      'period': 'all-time',
    };
  }

  /// Get daily activities for chart (last 7 days)
  Future<List<Map<String, dynamic>>> getDailyActivitiesChart(
      String userId) async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 6));

    List<Map<String, dynamic>> dailyData = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = startDate.add(Duration(days: i));
      DateTime dayStart = DateTime(day.year, day.month, day.day);
      DateTime dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);

      QuerySnapshot snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(dayEnd))
          .get();

      double totalWeight = 0;
      int totalPoints = 0;

      for (var doc in snapshot.docs) {
        RecyclingActivity activity = RecyclingActivity.fromFirestore(doc);
        totalWeight += activity.weight;
        totalPoints += activity.points;
      }

      dailyData.add({
        'date': dayStart,
        'weight': totalWeight,
        'points': totalPoints,
        'count': snapshot.docs.length,
      });
    }

    return dailyData;
  }
}
