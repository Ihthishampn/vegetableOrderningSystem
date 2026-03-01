import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

/// Concrete Firebase implementation of OrderRepository
class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore;
  static const String _ordersCollection = 'orders';

  OrderRepositoryImpl(this._firestore);

  @override
  Future<List<Order>> getOrdersByStore(String storeId) async {
    try {
      final snapshot = await _firestore
          .collection(_ordersCollection)
          .where('storeId', isEqualTo: storeId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Order.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      // Firestore may require a composite index for this query. When running
      // the app you might see a runtime warning with a link that allows you
      // to create the needed index in the Firebase console. If the index is
      // missing the call will fail with FAILED_PRECONDITION. We capture the
      // error and rethrow a more descriptive message to make the issue easier
      // to diagnose during development.
      if (e is FirebaseException && e.code == 'failed-precondition') {
        throw Exception(
          'Failed to fetch orders due to missing index. Create a composite '
          'index in Firestore for storeId + createdAt (see console link in log): $e',
        );
      }
      throw Exception('Error fetching orders: $e');
    }
  }

  @override
  Future<List<Order>> getOrdersByStatus(
    String storeId,
    OrderStatus status,
  ) async {
    try {
      final statusStr = status.toString().split('.').last;
      final snapshot = await _firestore
          .collection(_ordersCollection)
          .where('storeId', isEqualTo: storeId)
          .where('status', isEqualTo: statusStr)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Order.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error fetching orders by status: $e');
    }
  }

  @override
  Future<Order?> getOrderById(String storeId, String orderId) async {
    try {
      final doc = await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      if (data['storeId'] != storeId) return null;

      return Order.fromFirestore(data, doc.id);
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }

  @override
  Future<String> addOrder(Order order) async {
    try {
      final docRef = _firestore.collection(_ordersCollection).doc();
      final orderWithId = order.copyWith(id: docRef.id);
      await docRef.set(orderWithId.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Error adding order: $e');
    }
  }

  @override
  Future<void> updateOrder(
    String storeId,
    String orderId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = DateTime.now().toIso8601String();
      await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .update(updates);
    } catch (e) {
      throw Exception('Error updating order: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(
    String storeId,
    String orderId,
    OrderStatus newStatus,
  ) async {
    try {
      final statusStr = newStatus.toString().split('.').last;
      final updates = {
        'status': statusStr,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (newStatus == OrderStatus.completed) {
        updates['deliveredAt'] = DateTime.now().toIso8601String();
      }

      await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .update(updates);
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }

  @override
  Future<void> deleteOrder(String storeId, String orderId) async {
    // Instead of physically deleting the document we now mark the order as
    // cancelled.  This keeps the record in the database so it can be shown
    // in the "Cancelled" screens.  The previous behaviour was causing
    // cancelled orders to disappear entirely which confused users.
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).update({
        'status': 'cancelled',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error cancelling order: $e');
    }
  }

  @override
  Future<int> getPendingOrdersCount(String storeId) async {
    try {
      final snapshot = await _firestore
          .collection(_ordersCollection)
          .where('storeId', isEqualTo: storeId)
          .where('status', isEqualTo: 'pending')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Error fetching pending orders count: $e');
    }
  }

  @override
  Stream<List<Order>> watchOrdersByStore(String storeId) {
    return _firestore
        .collection(_ordersCollection)
        .where('storeId', isEqualTo: storeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Order.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<Order>> watchOrdersByStatus(String storeId, OrderStatus status) {
    final statusStr = status.toString().split('.').last;
    return _firestore
        .collection(_ordersCollection)
        .where('storeId', isEqualTo: storeId)
        .where('status', isEqualTo: statusStr)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Order.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }
}
