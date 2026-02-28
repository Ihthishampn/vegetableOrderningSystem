class Shop {
  final String id;
  final String storeId;
  final String shopName;
  final String address;
  final String city;
  final String phone;
  final String? managerName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Shop({
    required this.id,
    required this.storeId,
    required this.shopName,
    required this.address,
    required this.city,
    required this.phone,
    this.managerName,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  /// Convert Shop to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'shopName': shopName,
      'address': address,
      'city': city,
      'phone': phone,
      'managerName': managerName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  /// Create Shop from Firestore document
  factory Shop.fromFirestore(Map<String, dynamic> data, String id) {
    return Shop(
      id: id,
      storeId: data['storeId'] ?? '',
      shopName: data['shopName'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      phone: data['phone'] ?? '',
      managerName: data['managerName'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  /// Create a copy of Shop with modified fields
  Shop copyWith({
    String? id,
    String? storeId,
    String? shopName,
    String? address,
    String? city,
    String? phone,
    String? managerName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Shop(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      managerName: managerName ?? this.managerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
