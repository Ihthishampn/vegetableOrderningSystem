import '../../domain/entities/sales_report.dart';
import '../../domain/repositories/sales_report_repository.dart';

class SalesReportUseCase {
  final SalesReportRepository repository;

  SalesReportUseCase(this.repository);

  Future<List<SalesReport>> getSalesReportByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getSalesReportByStore(
      storeId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<SalesReport>> getSalesReportByShop(
    String storeId,
    String shopName, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getSalesReportByShop(
      storeId,
      shopName,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<SalesReport>> getSalesReportByShopId(
    String storeId,
    String shopId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getSalesReportByShopId(
      storeId,
      shopId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<double> getTotalSalesByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getTotalSalesByStore(
      storeId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
