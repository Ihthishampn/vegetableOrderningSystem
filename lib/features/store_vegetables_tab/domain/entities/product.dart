class Product {
  final String id;
  final String storeId;
  final String name;
  final String unit;
  final String? imageUrl;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.unit,
    this.imageUrl,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  Product copyWith({
    String? id,
    String? storeId,
    String? name,
    String? unit,
    String? imageUrl,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'category': unit,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      id: data['id'] as String? ?? '',
      storeId: data['storeId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      unit: data['category'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      isAvailable: data['isAvailable'] as bool? ?? true,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}