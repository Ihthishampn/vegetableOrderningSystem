import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepositoryImpl(this._firestore);

  static const String _productsCollection = 'products';

  CollectionReference<Map<String, dynamic>> _itemsRef(String storeId) =>
      _firestore
          .collection(_productsCollection)
          .doc(storeId)
          .collection('items');



  @override
  Future<List<Product>> getProductsByStore(String storeId) async {
    try {
      final snapshot = await _itemsRef(storeId).get();
      return snapshot.docs.map((doc) {
        
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Product.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<Product?> getProductById(String storeId, String productId) async {
    try {
      final doc = await _itemsRef(storeId).doc(productId).get();
      if (!doc.exists) return null;
      final data = Map<String, dynamic>.from(doc.data() ?? {});
      data['id'] = doc.id;
      return Product.fromFirestore(data);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByAvailability(
    String storeId,
    bool isAvailable,
  ) async {
    try {
      final snapshot = await _itemsRef(storeId)
          .where('isAvailable', isEqualTo: isAvailable)
          .get();
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Product.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products by availability: $e');
    }
  }



  @override
  Future<String> addProduct(Product product) async {
    try {
      final docRef = await _itemsRef(product.storeId).add(product.toFirestore());

      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      final docRef = _itemsRef(product.storeId).doc(product.id);

      final data = Map<String, dynamic>.from(product.toFirestore());

      if (product.imageUrl == null || product.imageUrl!.isEmpty) {
        data.remove('imageUrl');
        data['imageUrl'] = FieldValue.delete();
      }

      await docRef.update(data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String storeId, String productId) async {
    try {
      await _itemsRef(storeId).doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}