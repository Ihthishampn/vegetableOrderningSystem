class Staff {
  final String id;
  final String storeId;
  final String name;
  final String phone;
  final String email;
  final String position;
  final String address;
  final String? idProof;
  final DateTime dateOfJoining;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Staff({
    required this.id,
    required this.storeId,
    required this.name,
    required this.phone,
    required this.email,
    required this.position,
    required this.address,
    this.idProof,
    required this.dateOfJoining,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert Staff to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'name': name,
      'phone': phone,
      'email': email,
      'position': position,
      'address': address,
      'idProof': idProof,
      'dateOfJoining': dateOfJoining,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create Staff from Firestore document
  factory Staff.fromFirestore(Map<String, dynamic> data, String id) {
    return Staff(
      id: id,
      storeId: data['storeId'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      position: data['position'] ?? '',
      address: data['address'] ?? '',
      idProof: data['idProof'],
      dateOfJoining:
          (data['dateOfJoining'] as dynamic)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create a copy of Staff with modified fields
  Staff copyWith({
    String? id,
    String? storeId,
    String? name,
    String? phone,
    String? email,
    String? position,
    String? address,
    String? idProof,
    DateTime? dateOfJoining,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Staff(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      position: position ?? this.position,
      address: address ?? this.address,
      idProof: idProof ?? this.idProof,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
