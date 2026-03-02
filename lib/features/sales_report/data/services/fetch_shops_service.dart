import 'package:cloud_firestore/cloud_firestore.dart';

class FetchShopsService {
  final FirebaseFirestore firestore;

  FetchShopsService(this.firestore);

  Future<List<Shop>> fetchAllShops(String storeId) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection('shops')
          .withConverter<Map<String, dynamic>>(
            fromFirestore: (snap, _) => snap.data()!,
            toFirestore: (val, _) => val,
          );

      if (storeId.isNotEmpty) {
        query = query.where('storeId', isEqualTo: storeId);
      }

      final snapshot = await query.get();

      final List<Shop> shops = snapshot.docs.map((doc) {
        final data = doc.data();
        final mapData = Map<String, dynamic>.from(data);

        if ((mapData['shopName'] == null ||
                (mapData['shopName'] as String).isEmpty) &&
            mapData['shopname'] != null) {
          mapData['shopName'] = mapData['shopname'];
        }
        if ((mapData['shopName'] == null ||
                (mapData['shopName'] as String).isEmpty) &&
            mapData['customerName'] != null) {
          mapData['shopName'] = mapData['customerName'];
        }

        return Shop.fromFirestore(mapData, doc.id);
      }).toList();

      shops.sort(
        (a, b) => a.shopName.toLowerCase().compareTo(b.shopName.toLowerCase()),
      );

      return shops;
    } catch (e) {
      throw Exception('Failed to fetch shops: $e');
    }
  }
}

class Shop {
  final String id;
  final String storeId;
  final String shopName;
  final String address;
  final String city;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shop({
    required this.id,
    required this.storeId,
    required this.shopName,
    required this.address,
    required this.city,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shop.fromFirestore(Map<String, dynamic> data, String id) {
    return Shop(
      id: id,
      storeId: data['storeId'] ?? '',
      shopName: data['shopName'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      phone: data['phone'] ?? '',
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime.now();
      }
    }
    try {
      return (dateValue as dynamic).toDate();
    } catch (e) {
      return DateTime.now();
    }
  }
}
