import '../entities/order.dart';
import '../repositories/order_repository.dart';

class OrderUseCase {
  final OrderRepository repository;

  OrderUseCase(this.repository);

  Future<List<Order>> getOrdersByStore(String storeId) =>
      repository.getOrdersByStore(storeId);

  Future<List<Order>> getOrdersByStatus(String storeId, OrderStatus status) =>
      repository.getOrdersByStatus(storeId, status);

  Future<Order?> getOrderById(String storeId, String orderId) =>
      repository.getOrderById(storeId, orderId);

  Future<String> addOrder(Order order) => repository.addOrder(order);

  Future<void> updateOrder(
    String storeId,
    String orderId,
    Map<String, dynamic> updates,
  ) => repository.updateOrder(storeId, orderId, updates);

  Future<void> updateOrderStatus(
    String storeId,
    String orderId,
    OrderStatus newStatus,
  ) => repository.updateOrderStatus(storeId, orderId, newStatus);

 
  Future<void> deleteOrder(String storeId, String orderId) =>
      repository.deleteOrder(storeId, orderId);

  Future<int> getPendingOrdersCount(String storeId) =>
      repository.getPendingOrdersCount(storeId);

  Stream<List<Order>> watchOrdersByStore(String storeId) =>
      repository.watchOrdersByStore(storeId);

  Stream<List<Order>> watchOrdersByStatus(String storeId, OrderStatus status) =>
      repository.watchOrdersByStatus(storeId, status);
}
