import 'package:flutter/foundation.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/order_use_case.dart';

/// Manages order state for the store orders tab.
/// Handles loading, errors, and provides CRUD operations for orders.
class OrderProvider extends ChangeNotifier {
  final OrderUseCase useCase;

  OrderProvider(this.useCase);

  // State variables
  List<Order> _allOrders = [];
  List<Order> _pendingOrders = [];
  List<Order> _approvedOrders = [];
  List<Order> _completedOrders = [];
  List<Order> _rejectedOrders = [];
  bool _isLoading = false;
  String? _error;
  String? _storeId;

  // Getters
  List<Order> get allOrders => _allOrders;
  List<Order> get pendingOrders => _pendingOrders;
  List<Order> get approvedOrders => _approvedOrders;
  List<Order> get completedOrders => _completedOrders;
  List<Order> get rejectedOrders => _rejectedOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get storeId => _storeId;

  /// Initialize provider and fetch orders
  Future<void> initialize(String storeId) async {
    _storeId = storeId;
    await fetchOrders();
  }

  /// Fetch all orders and filter by status
  Future<void> fetchOrders() async {
    if (_storeId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allOrders = await useCase.getOrdersByStore(_storeId!);
      _filterOrdersByStatus();
      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    }
    notifyListeners();
  }

  /// Add new order
  Future<bool> addOrder({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required List<OrderItem> items,
    required double totalPrice,
    String? notes,
  }) async {
    if (_storeId == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final order = Order(
        id: '',
        storeId: _storeId!,
        customerId: customerId,
        customerName: customerName,
        customerPhone: customerPhone,
        deliveryAddress: deliveryAddress,
        items: items,
        totalPrice: totalPrice,
        status: OrderStatus.pending,
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await useCase.addOrder(order);
      _isLoading = false;

      // Refresh orders
      await fetchOrders();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    if (_storeId == null) return false;

    try {
      await useCase.updateOrderStatus(_storeId!, orderId, newStatus);
      await fetchOrders();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Approve order (change status to approved)
  Future<bool> approveOrder(String orderId) =>
      updateOrderStatus(orderId, OrderStatus.approved);

  /// Complete order (change status to completed)
  Future<bool> completeOrder(String orderId) =>
      updateOrderStatus(orderId, OrderStatus.completed);

  /// Reject order (change status to rejected)
  Future<bool> rejectOrder(String orderId) =>
      updateOrderStatus(orderId, OrderStatus.rejected);

  /// Update order with custom fields
  Future<bool> updateOrder(String orderId, Map<String, dynamic> updates) async {
    if (_storeId == null) return false;

    try {
      await useCase.updateOrder(_storeId!, orderId, updates);
      await fetchOrders();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete order
  Future<bool> deleteOrder(String orderId) async {
    if (_storeId == null) return false;

    try {
      await useCase.deleteOrder(_storeId!, orderId);
      await fetchOrders();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get pending orders count
  Future<int> getPendingOrdersCount() async {
    if (_storeId == null) return 0;
    try {
      return await useCase.getPendingOrdersCount(_storeId!);
    } catch (e) {
      return 0;
    }
  }

  /// Filter orders by status
  void _filterOrdersByStatus() {
    _pendingOrders = _allOrders
        .where((o) => o.status == OrderStatus.pending)
        .toList();
    _approvedOrders = _allOrders
        .where((o) => o.status == OrderStatus.approved)
        .toList();
    _completedOrders = _allOrders
        .where((o) => o.status == OrderStatus.completed)
        .toList();
    _rejectedOrders = _allOrders
        .where((o) => o.status == OrderStatus.rejected)
        .toList();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
