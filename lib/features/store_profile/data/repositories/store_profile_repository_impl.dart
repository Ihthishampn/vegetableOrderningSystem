import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/store_profile.dart';
import '../../domain/repositories/store_profile_repository.dart';

class StoreProfileRepositoryImpl implements StoreProfileRepository {
  final FirebaseFirestore _firestore;
  static const String _storesCollection = 'stores';

  StoreProfileRepositoryImpl(this._firestore);

  @override
  Future<StoreProfile?> getStoreProfileByUserId(String userId) async {
    try {
      final query = await _firestore
          .collection(_storesCollection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      return StoreProfile.fromFirestore(
        query.docs.first.data(),
        query.docs.first.id,
      );
    } catch (e) {
      throw Exception('Failed to fetch store profile: $e');
    }
  }

  @override
  Future<void> updateStoreProfile(StoreProfile storeProfile) async {
    try {
      await _firestore
          .collection(_storesCollection)
          .doc(storeProfile.id)
          .update(storeProfile.toFirestore());
    } catch (e) {
      throw Exception('Failed to update store profile: $e');
    }
  }

  @override
  Future<void> createStoreProfile(StoreProfile storeProfile) async {
    try {
      await _firestore
          .collection(_storesCollection)
          .doc(storeProfile.id)
          .set(storeProfile.toFirestore());
    } catch (e) {
      throw Exception('Failed to create store profile: $e');
    }
  }
}
