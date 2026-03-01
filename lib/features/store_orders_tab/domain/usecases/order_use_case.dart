import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// Business logic wrapper for order operations
class OrderUseCase {
  final OrderRepository repository;

  OrderUseCase(this.repository);

  /// Get all orders for a store
  Future<List<Order>> getOrdersByStore(String storeId) =>
      repository.getOrdersByStore(storeId);

  /// Get orders filtered by status
  Future<List<Order>> getOrdersByStatus(String storeId, OrderStatus status) =>
      repository.getOrdersByStatus(storeId, status);

  /// Get specific order
  Future<Order?> getOrderById(String storeId, String orderId) =>
      repository.getOrderById(storeId, orderId);

  /// Create new order
  Future<String> addOrder(Order order) => repository.addOrder(order);

  /// Update order
  Future<void> updateOrder(
    String storeId,
    String orderId,
    Map<String, dynamic> updates,
  ) => repository.updateOrder(storeId, orderId, updates);

  /// Update order status
  Future<void> updateOrderStatus(
    String storeId,
    String orderId,
    OrderStatus newStatus,
  ) => repository.updateOrderStatus(storeId, orderId, newStatus);

  /// Delete order
  /// Cancel order (formerly called delete).
  ///
  /// The underlying repository used to actually perform the operation now
  /// updates the order's status to `cancelled` rather than removing it from
  /// Firestore, allowing the record to be visible in cancelled lists.  We
  /// keep the method name for backwards compatibility with the provider but
  /// have updated the documentation accordingly.
  Future<void> deleteOrder(String storeId, String orderId) =>
      repository.deleteOrder(storeId, orderId);

  /// Get pending orders count
  Future<int> getPendingOrdersCount(String storeId) =>
      repository.getPendingOrdersCount(storeId);

  /// Stream of all orders for a store
  Stream<List<Order>> watchOrdersByStore(String storeId) =>
      repository.watchOrdersByStore(storeId);

  /// Stream of orders by status
  Stream<List<Order>> watchOrdersByStatus(String storeId, OrderStatus status) =>
      repository.watchOrdersByStatus(storeId, status);
}
