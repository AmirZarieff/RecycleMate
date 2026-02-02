import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scan_record.dart';

class ScanHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'scan_history';

  CollectionReference get _collection => _firestore.collection(collectionName);

  Future<String> addRecord(ScanRecord record) async {
    try {
      final docRef = await _collection.add(record.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add scan record: $e');
    }
  }

  Stream<List<ScanRecord>> streamUserRecords(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(ScanRecord.fromFirestore).toList();
    });
  }

  Future<void> updateRecord(ScanRecord record) async {
    try {
      await _collection.doc(record.id).update(record.toMap());
    } catch (e) {
      throw Exception('Failed to update scan record: $e');
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      await _collection.doc(recordId).delete();
    } catch (e) {
      throw Exception('Failed to delete scan record: $e');
    }
  }
}
