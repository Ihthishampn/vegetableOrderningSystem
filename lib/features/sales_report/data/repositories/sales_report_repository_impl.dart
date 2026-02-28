import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sales_report.dart';
import '../../domain/repositories/sales_report_repository.dart';

class SalesReportRepositoryImpl implements SalesReportRepository {
  final FirebaseFirestore _firestore;
  static const String _ordersCollection = 'orders';

  SalesReportRepositoryImpl(this._firestore);

  @override
  Future<List<SalesReport>> getSalesReportByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _firestore
          .collection(_ordersCollection)
          .where('storeId', isEqualTo: storeId)
          .where('status', isEqualTo: 'completed')
          .orderBy('deliveredAt', descending: true);

      if (startDate != null) {
        query = query.where('deliveredAt', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('deliveredAt', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      final reports = <SalesReport>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final items = <SalesItem>[];

        if (data['items'] != null) {
          for (final item in data['items']) {
            items.add(
              SalesItem(
                productName: item['productName'] ?? '',
                quantity: (item['quantity'] ?? 0).toDouble(),
                unit: item['unit'] ?? '',
                pricePerUnit: (item['price'] ?? 0).toDouble(),
                totalPrice: ((item['quantity'] ?? 0) * (item['price'] ?? 0))
                    .toDouble(),
              ),
            );
          }
        }

        reports.add(
          SalesReport(
            orderId: doc.id,
            shopName: data['shopName'] ?? 'Unknown',
            date: (data['deliveredAt'] as dynamic)?.toDate() ?? DateTime.now(),
            items: items,
            totalAmount: (data['totalPrice'] ?? 0).toDouble(),
          ),
        );
      }

      return reports;
    } catch (e) {
      throw Exception('Failed to fetch sales reports: $e');
    }
  }

  @override
  Future<List<SalesReport>> getSalesReportByShop(
    String storeId,
    String shopName, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _firestore
          .collection(_ordersCollection)
          .where('storeId', isEqualTo: storeId)
          .where('shopName', isEqualTo: shopName)
          .where('status', isEqualTo: 'completed')
          .orderBy('deliveredAt', descending: true);

      if (startDate != null) {
        query = query.where('deliveredAt', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('deliveredAt', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      final reports = <SalesReport>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final items = <SalesItem>[];

        if (data['items'] != null) {
          for (final item in data['items']) {
            items.add(
              SalesItem(
                productName: item['productName'] ?? '',
                quantity: (item['quantity'] ?? 0).toDouble(),
                unit: item['unit'] ?? '',
                pricePerUnit: (item['price'] ?? 0).toDouble(),
                totalPrice: ((item['quantity'] ?? 0) * (item['price'] ?? 0))
                    .toDouble(),
              ),
            );
          }
        }

        reports.add(
          SalesReport(
            orderId: doc.id,
            shopName: data['shopName'] ?? 'Unknown',
            date: (data['deliveredAt'] as dynamic)?.toDate() ?? DateTime.now(),
            items: items,
            totalAmount: (data['totalPrice'] ?? 0).toDouble(),
          ),
        );
      }

      return reports;
    } catch (e) {
      throw Exception('Failed to fetch sales reports by shop: $e');
    }
  }

  @override
  Future<double> getTotalSalesByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _firestore
          .collection(_ordersCollection)
          .where('storeId', isEqualTo: storeId)
          .where('status', isEqualTo: 'completed');

      if (startDate != null) {
        query = query.where('deliveredAt', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('deliveredAt', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      double total = 0;

      for (final doc in snapshot.docs) {
        total += (doc['totalPrice'] ?? 0).toDouble();
      }

      return total;
    } catch (e) {
      throw Exception('Failed to fetch total sales: $e');
    }
  }
}
