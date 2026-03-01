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

  /// Fetch all shops from the shops collection for this store
  Future<void> _fetchAllShops() async {
    try {
      // Fetch shops for this store. Use _storeId if available to limit results.
      // Use Query type since adding a `where` clause returns a Query, not a
      // CollectionReference.  Avoid type mismatch by explicitly declaring.
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

      // Map documents to Shop objects safely. Use a defensive cast to Map<String, dynamic>.
      _allShops = snapshot.docs.map((doc) {
        final data = doc.data();
        // data is already Map<String, dynamic> thanks to the query converter
        final mapData = Map<String, dynamic>.from(data);

        // Normalize potential field-name differences from Firestore:
        // - 'shopName' (preferred)
        // - 'shopname' (lowercase)
        // - 'customerName' (some setups store display name here)
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

      // Sort shops by name (case-insensitive) so UI shows stable ordering.
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
      // Prefer fetching by shopId (stable identifier) if we can resolve it.
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
        // Fallback to name-based query if shopId not available
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

    // Resolve shopId for the selected shop name if possible
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

    // If a specific shop selected, fetch reports filtered by that shop (prefer shopId)
    if (_selectedShop != 'All' && _storeId != null) {
      fetchReportsByShop(_selectedShop);
    } else {
      // Reset to full reports
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

  /// Get all shops including those with and without sales data
  List<String> getAllShopNames() {
    // If we have shops loaded from the collection, prefer them.
    if (_allShops.isNotEmpty) {
      final shopNames = _allShops.map((shop) => shop.shopName).toSet().toList();
      shopNames.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return ['All', ...shopNames];
    }

    // Fallback: derive shop names from sales reports (useful if shops collection isn't populated).
    final fallback = _allReports
        .map((report) => report.shopName)
        .toSet()
        .toList();
    fallback.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return ['All', ...fallback];
  }

  /// Get unique shops from sales reports
  List<String> getUniqueShops() {
    final shops = _allReports.map((report) => report.shopName).toSet().toList();
    shops.sort();
    return ['All', ...shops];
  }
}
