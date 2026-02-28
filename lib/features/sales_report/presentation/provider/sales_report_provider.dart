import 'package:flutter/material.dart';
import '../../domain/entities/sales_report.dart';
import '../../domain/usecases/sales_report_use_case.dart';

class SalesReportProvider with ChangeNotifier {
  final SalesReportUseCase _useCase;

  SalesReportProvider(this._useCase);

  List<SalesReport> _allReports = [];
  List<SalesReport> _filteredReports = [];
  double _totalSales = 0;
  bool _isLoading = false;
  String? _error;
  String? _storeId;
  String _selectedShop = 'All';

  List<SalesReport> get allReports => _allReports;
  List<SalesReport> get filteredReports => _filteredReports;
  double get totalSales => _totalSales;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedShop => _selectedShop;

  Future<void> initialize(String storeId) async {
    _storeId = storeId;
    await fetchSalesReports();
  }

  Future<void> fetchSalesReports({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_storeId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allReports = await _useCase.getSalesReportByStore(
        _storeId!,
        startDate: startDate,
        endDate: endDate,
      );
      _totalSales = await _useCase.getTotalSalesByStore(
        _storeId!,
        startDate: startDate,
        endDate: endDate,
      );
      _filterReports();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReportsByShop(
    String shopName, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_storeId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _filteredReports = await _useCase.getSalesReportByShop(
        _storeId!,
        shopName,
        startDate: startDate,
        endDate: endDate,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedShop(String shopName) {
    _selectedShop = shopName;
    _filterReports();
    notifyListeners();
  }

  void _filterReports() {
    if (_selectedShop == 'All') {
      _filteredReports = _allReports;
    } else {
      _filteredReports = _allReports
          .where((report) => report.shopName == _selectedShop)
          .toList();
    }
  }

  List<String> getUniqueShops() {
    final shops = _allReports.map((report) => report.shopName).toSet().toList();
    return ['All', ...shops];
  }
}
