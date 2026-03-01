import '../entities/sales_report.dart';

abstract class SalesReportRepository {
  Future<List<SalesReport>> getSalesReportByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<SalesReport>> getSalesReportByShop(
    String storeId,
    String shopName, {
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<SalesReport>> getSalesReportByShopId(
    String storeId,
    String shopId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<double> getTotalSalesByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}
