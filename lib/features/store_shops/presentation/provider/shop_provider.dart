import 'package:flutter/material.dart';
import '../../domain/entities/shop.dart';
import '../../domain/usecases/shop_use_case.dart';

class ShopProvider with ChangeNotifier {
  final ShopUseCase _useCase;

  ShopProvider(this._useCase);

  List<Shop> _shopList = [];
  bool _isLoading = false;
  String? _error;
  String? _storeId;

  Shop? _currentShop;
  bool _isLoadingSingleShop = false;
  String? _errorSingleShop;

  List<Shop> get shopList => _shopList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Shop? get currentShop => _currentShop;
  bool get isLoadingSingleShop => _isLoadingSingleShop;
  String? get errorSingleShop => _errorSingleShop;

  Future<void> initialize(String storeId) async {
    _storeId = storeId;
    await fetchShops();
  }

  Future<void> fetchShops() async {
    if (_storeId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _shopList = await _useCase.getShopsByStore(_storeId!);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchShopById(String storeId, String shopId) async {
    _isLoadingSingleShop = true;
    _errorSingleShop = null;
    notifyListeners();

    try {
      _currentShop = await _useCase.getShopById(storeId, shopId);
      _isLoadingSingleShop = false;
      notifyListeners();
    } catch (e) {
      _errorSingleShop = e.toString();
      _isLoadingSingleShop = false;
      notifyListeners();
    }
  }

  Future<bool> addShop(Shop shop) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    if (shop.shopName.trim().isEmpty ||
        shop.address.trim().isEmpty ||
        shop.city.trim().isEmpty ||
        shop.phone.trim().isEmpty ||
        (shop.managerName ?? '').trim().isEmpty) {
      _error = 'All shop fields are required';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final id = await _useCase.addShop(shop);
      _shopList.add(shop.copyWith(id: id));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateShop(Shop shop) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _useCase.updateShop(shop);
      final index = _shopList.indexWhere((s) => s.id == shop.id);
      if (index != -1) {
        _shopList[index] = shop;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteShop(String shopId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _useCase.deleteShop(_storeId!, shopId);
      _shopList.removeWhere((s) => s.id == shopId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleShopStatus(String shopId, bool isActive) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _useCase.toggleShopStatus(_storeId!, shopId, isActive);
      final index = _shopList.indexWhere((s) => s.id == shopId);
      if (index != -1) {
        _shopList[index] = _shopList[index].copyWith(isActive: isActive);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
