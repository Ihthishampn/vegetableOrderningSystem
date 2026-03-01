import '../entities/sales_report.dart';
import '../repositories/sales_report_repository.dart';


class FetchSalesReportsUseCase {
  final SalesReportRepository repository;

  FetchSalesReportsUseCase(this.repository);

  Future<List<SalesReport>> byStore(
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

  Future<List<SalesReport>> byShop(
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

  Future<List<SalesReport>> byShopId(
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

  Future<double> totalSalesByStore(
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

class SalesReportUseCase extends FetchSalesReportsUseCase {
  SalesReportUseCase(super.repository);

  Future<List<SalesReport>> getSalesReportByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) => byStore(storeId, startDate: startDate, endDate: endDate);

  Future<List<SalesReport>> getSalesReportByShop(
    String storeId,
    String shopName, {
    DateTime? startDate,
    DateTime? endDate,
  }) => byShop(storeId, shopName, startDate: startDate, endDate: endDate);

  Future<List<SalesReport>> getSalesReportByShopId(
    String storeId,
    String shopId, {
    DateTime? startDate,
    DateTime? endDate,
  }) => byShopId(storeId, shopId, startDate: startDate, endDate: endDate);

  Future<double> getTotalSalesByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) => totalSalesByStore(storeId, startDate: startDate, endDate: endDate);
}
