import 'package:flutter/foundation.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/order_use_case.dart';
import '../../../store_shops/domain/usecases/shop_use_case.dart';


class OrderProvider extends ChangeNotifier {
  final OrderUseCase useCase;
  final ShopUseCase _shopUseCase;

  OrderProvider(this.useCase, this._shopUseCase);

  List<Order> _allOrders = [];
  List<Order> _pendingOrders = [];
  List<Order> _approvedOrders = [];
  List<Order> _completedOrders = [];
  List<Order> _rejectedOrders = [];
  List<Order> _cancelledOrders = [];
  bool _isLoading = false;
  String? _error;
  String? _storeId;

  List<Order> get allOrders => _allOrders;
  List<Order> get pendingOrders => _pendingOrders;
  List<Order> get approvedOrders => _approvedOrders;
  List<Order> get completedOrders => _completedOrders;
  List<Order> get rejectedOrders => _rejectedOrders;
  List<Order> get cancelledOrders => _cancelledOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get storeId => _storeId;

  Future<void> initialize(String storeId) async {
    _storeId = storeId;
    await fetchOrders();
  }

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

  Future<bool> addOrder({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required List<OrderItem> items,
    String? notes,
    DateTime? scheduledDate,
    String? shopId,
  }) async {

    if (customerName.trim().isEmpty) {
      customerName = 'Shop';
    }
    if (_storeId == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      String? resolvedShopId = shopId;
      if (resolvedShopId == null && customerId.isNotEmpty && _storeId != null) {
        try {
          final shop = await _shopUseCase.getShopById(_storeId!, customerId);
          if (shop != null) resolvedShopId = shop.id;
        } catch (_) {
        }
      }

      final order = Order(
        id: '',
        storeId: _storeId!,
        shopId: resolvedShopId,
        customerId: customerId,
        customerName: customerName,
        customerPhone: customerPhone,
        items: items,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        scheduledDate: scheduledDate,
      );

      await useCase.addOrder(order);
      _isLoading = false;

      await fetchOrders();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

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

  Future<bool> approveOrder(String orderId) =>
      updateOrderStatus(orderId, OrderStatus.approved);

  Future<bool> completeOrder(String orderId) =>
      updateOrderStatus(orderId, OrderStatus.completed);

  Future<bool> rejectOrder(String orderId) =>
      updateOrderStatus(orderId, OrderStatus.rejected);

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

  Future<int> getPendingOrdersCount() async {
    if (_storeId == null) return 0;
    try {
      return await useCase.getPendingOrdersCount(_storeId!);
    } catch (e) {
      return 0;
    }
  }

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
    _cancelledOrders = _allOrders
        .where((o) => o.status == OrderStatus.cancelled)
        .toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
