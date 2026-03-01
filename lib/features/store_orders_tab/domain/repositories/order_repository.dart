import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrdersByStore(String storeId);

  Future<List<Order>> getOrdersByStatus(String storeId, OrderStatus status);

  Future<Order?> getOrderById(String storeId, String orderId);

  Future<String> addOrder(Order order);

  Future<void> updateOrder(
    String storeId,
    String orderId,
    Map<String, dynamic> updates,
  );

  Future<void> updateOrderStatus(
    String storeId,
    String orderId,
    OrderStatus newStatus,
  );

  Future<void> deleteOrder(String storeId, String orderId);

  Future<int> getPendingOrdersCount(String storeId);

  Stream<List<Order>> watchOrdersByStore(String storeId);

  Stream<List<Order>> watchOrdersByStatus(String storeId, OrderStatus status);
}
