import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/shop.dart';
import '../../domain/repositories/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  final FirebaseFirestore _firestore;
  static const String _shopsCollection = 'shops';

  ShopRepositoryImpl(this._firestore);

  @override
  Future<List<Shop>> getShopsByStore(String storeId) async {
    try {
      final snapshot = await _firestore
          .collection(_shopsCollection)
          .where('storeId', isEqualTo: storeId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Shop.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch shops: $e');
    }
  }

  @override
  Future<Shop?> getShopById(String storeId, String shopId) async {
    try {
      final doc = await _firestore
          .collection(_shopsCollection)
          .doc(shopId)
          .get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      if (data['storeId'] != storeId) return null;

      return Shop.fromFirestore(data, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch shop: $e');
    }
  }

  /// Get a shop by phone number (for shop login verification).
  Future<Shop?> getShopByPhone(String phone) async {
    try {
      final snapshot = await _firestore
          .collection(_shopsCollection)
          .where('phone', isEqualTo: phone.trim())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return Shop.fromFirestore(doc.data(), doc.id);
    } catch (e) {
      throw Exception('Failed to fetch shop by phone: $e');
    }
  }

  @override
  Future<String> addShop(Shop shop) async {
    try {
      final docRef = await _firestore
          .collection(_shopsCollection)
          .add(shop.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add shop: $e');
    }
  }

  @override
  Future<void> updateShop(Shop shop) async {
    try {
      await _firestore
          .collection(_shopsCollection)
          .doc(shop.id)
          .update(shop.toFirestore());
    } catch (e) {
      throw Exception('Failed to update shop: $e');
    }
  }

  @override
  Future<void> deleteShop(String storeId, String shopId) async {
    try {
      await _firestore.collection(_shopsCollection).doc(shopId).delete();
    } catch (e) {
      throw Exception('Failed to delete shop: $e');
    }
  }

  @override
  Future<void> toggleShopStatus(
    String storeId,
    String shopId,
    bool isActive,
  ) async {
    try {
      await _firestore.collection(_shopsCollection).doc(shopId).update({
        'isActive': isActive,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to toggle shop status: $e');
    }
  }
}
