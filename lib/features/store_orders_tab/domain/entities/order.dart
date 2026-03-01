/// Represents an order placed by a customer to a store.
class Order {
  final String id;
  final String storeId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final List<OrderItem> items;
  final double totalPrice;
  final OrderStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  /// Optional date the customer asked for delivery (used when scheduling)
  final DateTime? scheduledDate;

  Order({
    required this.id,
    required this.storeId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.items,
    required this.totalPrice,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
    this.scheduledDate,
  });

  /// Convert Order to Firestore document map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'storeId': storeId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'scheduledDate': scheduledDate?.toIso8601String(),
    };
  }

  /// Create Order from Firestore document map
  factory Order.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Order(
      id: documentId,
      storeId: data['storeId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      deliveryAddress: data['deliveryAddress'] ?? '',
      items:
          (data['items'] as List?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: _parseStatus(data['status'] as String? ?? 'pending'),
      notes: data['notes'],
      createdAt: DateTime.parse(
        data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        data['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      deliveredAt: data['deliveredAt'] != null
          ? DateTime.parse(data['deliveredAt'] as String)
          : null,
      scheduledDate: data['scheduledDate'] != null
          ? DateTime.parse(data['scheduledDate'] as String)
          : null,
    );
  }

  /// Immutable copy with updates
  Order copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? deliveryAddress,
    List<OrderItem>? items,
    double? totalPrice,
    OrderStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
  }) {
    return Order(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      scheduledDate: scheduledDate ?? this.scheduledDate,
    );
  }

  static OrderStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'approved':
        return OrderStatus.approved;
      case 'completed':
        return OrderStatus.completed;
      case 'rejected':
        return OrderStatus.rejected;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}

/// Individual item within an order
class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? unit;
  final double subtotal;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.unit,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'subtotal': subtotal,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] as String?,
      subtotal: (map['subtotal'] ?? 0).toDouble(),
    );
  }
}

/// Order status enum
///
/// A cancelled value has been added so that cancelled orders remain in the
/// database and can be displayed rather than being hard-deleted.
enum OrderStatus { pending, approved, completed, rejected, cancelled }
