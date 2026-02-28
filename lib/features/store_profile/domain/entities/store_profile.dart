class StoreProfile {
  final String id;
  final String storeName;
  final String ownerName;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String? licenseNumber;
  final String? gstNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreProfile({
    required this.id,
    required this.storeName,
    required this.ownerName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    this.licenseNumber,
    this.gstNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert StoreProfile to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'storeName': storeName,
      'ownerName': ownerName,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'licenseNumber': licenseNumber,
      'gstNumber': gstNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create StoreProfile from Firestore document
  factory StoreProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return StoreProfile(
      id: id,
      storeName: data['storeName'] ?? '',
      ownerName: data['ownerName'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      pinCode: data['pinCode'] ?? '',
      licenseNumber: data['licenseNumber'],
      gstNumber: data['gstNumber'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create a copy of StoreProfile with modified fields
  StoreProfile copyWith({
    String? id,
    String? storeName,
    String? ownerName,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? licenseNumber,
    String? gstNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreProfile(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      gstNumber: gstNumber ?? this.gstNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
