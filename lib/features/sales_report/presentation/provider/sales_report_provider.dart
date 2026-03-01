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
  String? _selectedShopId;

  List<SalesReport> get allReports => _allReports;
  List<SalesReport> get filteredReports => _filteredReports;
  List<Shop> get allShops => _allShops;
  String? get selectedShopId => _selectedShopId;
  double get totalSales => _totalSales;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedShop => _selectedShop;

  Future<void> initialize(String storeId) async {
    _storeId = storeId;
    await Future.wait([_fetchAllShops(), fetchSalesReports()]);
  }

  Future<void> _fetchAllShops() async {
    try {
  
      Query<Map<String, dynamic>> query = _firestore
          .collection('shops')
          .withConverter<Map<String, dynamic>>(
            fromFirestore: (snap, _) => snap.data()!,
            toFirestore: (val, _) => val,
          );
      if (_storeId != null && _storeId!.isNotEmpty) {
        query = query.where('storeId', isEqualTo: _storeId!);
      }

      final snapshot = await query.get();

      debugPrint(
        'Fetched ${snapshot.docs.length} shops from `shops` collection',
      );

      _allShops = snapshot.docs.map((doc) {
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

        final shop = Shop.fromFirestore(mapData, doc.id);
        debugPrint('Shop loaded: ${shop.shopName} (id: ${shop.id})');
        return shop;
      }).toList();

      _allShops.sort(
        (a, b) => a.shopName.toLowerCase().compareTo(b.shopName.toLowerCase()),
      );

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
      final shopObj = _allShops.firstWhere(
        (s) => s.shopName == shopName,
        orElse: () => Shop(
          id: '',
          storeId: '',
          shopName: '',
          address: '',
          city: '',
          phone: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      if (shopObj.id.isNotEmpty) {
        _filteredReports = await _useCase.getSalesReportByShopId(
          _storeId!,
          shopObj.id,
          startDate: startDate,
          endDate: endDate,
        );
      } else {
        _filteredReports = await _useCase.getSalesReportByShop(
          _storeId!,
          shopName,
          startDate: startDate,
          endDate: endDate,
        );
      }
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

    final matched = _allShops.firstWhere(
      (s) => s.shopName == shopName,
      orElse: () => Shop(
        id: '',
        storeId: '',
        shopName: '',
        address: '',
        city: '',
        phone: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    _selectedShopId = matched.id.isNotEmpty ? matched.id : null;

    if (_selectedShop != 'All' && _storeId != null) {
      fetchReportsByShop(_selectedShop);
    } else {
      _filterReports();
      notifyListeners();
    }
  }

  void _filterReports() {
    if (_selectedShop == 'All') {
      _filteredReports = _allReports;
    } else if (_selectedShopId != null && _selectedShopId!.isNotEmpty) {
      _filteredReports = _allReports
          .where((report) => (report.shopId) == _selectedShopId)
          .toList();
    } else {
      _filteredReports = _allReports
          .where((report) => report.shopName == _selectedShop)
          .toList();
    }
  }

  List<String> getAllShopNames() {
    if (_allShops.isNotEmpty) {
      final shopNames = _allShops.map((shop) => shop.shopName).toSet().toList();
      shopNames.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return ['All', ...shopNames];
    }

    final fallback = _allReports
        .map((report) => report.shopName)
        .toSet()
        .toList();
    fallback.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return ['All', ...fallback];
  }

  List<String> getUniqueShops() {
    final shops = _allReports.map((report) => report.shopName).toSet().toList();
    shops.sort();
    return ['All', ...shops];
  }
}
