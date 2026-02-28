import '../entities/order.dart';

/// Abstract repository for order operations
abstract class OrderRepository {
  /// Get all orders for a specific store
  Future<List<Order>> getOrdersByStore(String storeId);

  /// Get orders for a store filtered by status
  Future<List<Order>> getOrdersByStatus(String storeId, OrderStatus status);

  /// Get a specific order by ID
  Future<Order?> getOrderById(String storeId, String orderId);

  /// Add a new order
  Future<String> addOrder(Order order);

  /// Update an existing order
  Future<void> updateOrder(
    String storeId,
    String orderId,
    Map<String, dynamic> updates,
  );

  /// Update order status
  Future<void> updateOrderStatus(
    String storeId,
    String orderId,
    OrderStatus newStatus,
  );

  /// Delete an order
  Future<void> deleteOrder(String storeId, String orderId);

  /// Get pending orders count
  Future<int> getPendingOrdersCount(String storeId);

  /// Get orders with real-time updates (stream)
  Stream<List<Order>> watchOrdersByStore(String storeId);

  /// Get orders by status with real-time updates
  Stream<List<Order>> watchOrdersByStatus(String storeId, OrderStatus status);
}
