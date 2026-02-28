import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/staff.dart';
import '../../domain/repositories/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final FirebaseFirestore _firestore;
  static const String _staffCollection = 'staff';

  StaffRepositoryImpl(this._firestore);

  @override
  Future<List<Staff>> getStaffByStore(String storeId) async {
    try {
      final snapshot = await _firestore
          .collection(_staffCollection)
          .where('storeId', isEqualTo: storeId)
          .orderBy('dateOfJoining', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Staff.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch staff: $e');
    }
  }

  @override
  Future<Staff?> getStaffById(String storeId, String staffId) async {
    try {
      final doc = await _firestore
          .collection(_staffCollection)
          .doc(staffId)
          .get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      if (data['storeId'] != storeId) return null;

      return Staff.fromFirestore(data, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch staff: $e');
    }
  }

  @override
  Future<String> addStaff(Staff staff) async {
    try {
      final docRef = await _firestore
          .collection(_staffCollection)
          .add(staff.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add staff: $e');
    }
  }

  @override
  Future<void> updateStaff(Staff staff) async {
    try {
      await _firestore
          .collection(_staffCollection)
          .doc(staff.id)
          .update(staff.toFirestore());
    } catch (e) {
      throw Exception('Failed to update staff: $e');
    }
  }

  @override
  Future<void> deleteStaff(String storeId, String staffId) async {
    try {
      await _firestore.collection(_staffCollection).doc(staffId).delete();
    } catch (e) {
      throw Exception('Failed to delete staff: $e');
    }
  }

  @override
  Future<void> toggleStaffStatus(
    String storeId,
    String staffId,
    bool isActive,
  ) async {
    try {
      await _firestore.collection(_staffCollection).doc(staffId).update({
        'isActive': isActive,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to toggle staff status: $e');
    }
  }
}
