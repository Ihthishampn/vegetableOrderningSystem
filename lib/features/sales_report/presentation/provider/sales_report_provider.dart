import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sales_report.dart';
import '../../domain/usecases/sales_report_use_case.dart';
import '../../../store_shops/domain/entities/shop.dart';

class SalesReportProvider with ChangeNotifier {
  final SalesReportUseCase _useCase;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SalesReportProvider(this._useCase);

  List<SalesReport> _allReports = [];
  List<SalesReport> _filteredReports = [];
  List<Shop> _allShops = [];
  double _totalSales = 0;
  bool _isLoading = false;
  String? _error;
  String? _storeId;
  String _selectedShop = 'All';

  List<SalesReport> get allReports => _allReports;
  List<SalesReport> get filteredReports => _filteredReports;
  List<Shop> get allShops => _allShops;
  double get totalSales => _totalSales;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedShop => _selectedShop;

  Future<void> initialize(String storeId) async {
    _storeId = storeId;
    await Future.wait([_fetchAllShops(), fetchSalesReports()]);
  }

  /// Fetch all shops from the shops collection for this store
  Future<void> _fetchAllShops() async {
    if (_storeId == null) return;

    try {
      final snapshot = await _firestore
          .collection('shops')
          .where('storeId', isEqualTo: _storeId!)
          .orderBy('shopname')
          .get();

      debugPrint(
        'Fetched ${snapshot.docs.length} shops for storeId: $_storeId',
      );

      _allShops = snapshot.docs.map((doc) {
        final shop = Shop.fromFirestore(doc.data(), doc.id);
        debugPrint('Shop loaded: ${shop.shopName}');
        return shop;
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching shops: $e');
      _allShops = [];
      notifyListeners();
    }
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

  /// Get all shops including those with and without sales data
  List<String> getAllShopNames() {
    // If we have shops loaded, use them
    if (_allShops.isNotEmpty) {
      final shopNames = _allShops.map((shop) => shop.shopName).toList();
      return ['All', ...shopNames];
    }

    // Fallback: if no shops loaded, try to get shops from sales reports
    final shopNames = _allReports
        .map((report) => report.shopName)
        .toSet()
        .toList();
    shopNames.sort();
    return ['All', ...shopNames];
  }

  /// Get unique shops from sales reports
  List<String> getUniqueShops() {
    final shops = _allReports.map((report) => report.shopName).toSet().toList();
    shops.sort();
    return ['All', ...shops];
  }
}
