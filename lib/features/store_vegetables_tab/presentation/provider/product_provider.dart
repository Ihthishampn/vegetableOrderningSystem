import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/product_use_case.dart';

class ProductProvider extends ChangeNotifier {
  final ProductUseCase useCase;

  ProductProvider(this.useCase);

  List<Product> _allProducts = [];
  List<Product> _availableProducts = [];
  List<Product> _unavailableProducts = [];
  bool _isLoading = false;
  String? _error;
  String? _storeId;

  List<Product> get allProducts => _allProducts;
  List<Product> get availableProducts => _availableProducts;
  List<Product> get unavailableProducts => _unavailableProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get storeId => _storeId;

  Future<void> initialize(String storeId) async {
    _storeId = storeId;
    await fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (_storeId == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _allProducts = await useCase.getProducts(_storeId!);
      _availableProducts = await useCase.getAvailableProducts(_storeId!);
      _unavailableProducts = await useCase.getUnavailableProducts(_storeId!);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct({
    required String name,
    required String category,
    required double price,
    required int stock,
    required int minStock,
    String? description,
    String? imageUrl,
  }) async {
    if (_storeId == null) {
      _error = 'Store ID not set';
      notifyListeners();
      return false;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
  
      final product = Product(
        id: '',
        storeId: _storeId!,
        name: name,
        unit: category,
        imageUrl: imageUrl,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await useCase.addProduct(product);
      await fetchProducts();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct({
    required String productId,
    required String name,
    required String unit,
    String? imageUrl,
    required bool isAvailable,
    bool refresh = true,
  }) async {
    if (_storeId == null) {
      _error = 'Store ID not set';
      notifyListeners();
      return false;
    }
    if (refresh) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }
    try {
      final product = Product(
        id: productId,
        storeId: _storeId!,
        name: name,
        unit: unit,
        imageUrl: imageUrl,
        isAvailable: isAvailable,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await useCase.updateProduct(product);
      if (refresh) {
        await fetchProducts();
      } else {
        final idx = _allProducts.indexWhere((p) => p.id == productId);
        if (idx != -1) _allProducts[idx] = product;
        _availableProducts = _allProducts.where((p) => p.isAvailable).toList();
        _unavailableProducts = _allProducts
            .where((p) => !p.isAvailable)
            .toList();
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      if (refresh) notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    if (_storeId == null) {
      _error = 'Store ID not set';
      notifyListeners();
      return false;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await useCase.deleteProduct(_storeId!, productId);
      await fetchProducts();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleAvailability(Product product) async {
    final newAvailability = !product.isAvailable;

    final updated = product.copyWith(isAvailable: newAvailability);
    final idx = _allProducts.indexWhere((p) => p.id == product.id);
    if (idx != -1) _allProducts[idx] = updated;
    _availableProducts = _allProducts.where((p) => p.isAvailable).toList();
    _unavailableProducts = _allProducts.where((p) => !p.isAvailable).toList();
    notifyListeners();

    final success = await updateProduct(
      productId: product.id,
      name: product.name,
      unit: product.unit,
      imageUrl: product.imageUrl,
      isAvailable: newAvailability,
      refresh: false,
    );

    if (!success) {
      final revertIdx = _allProducts.indexWhere((p) => p.id == product.id);
      if (revertIdx != -1) _allProducts[revertIdx] = product;
      _availableProducts = _allProducts.where((p) => p.isAvailable).toList();
      _unavailableProducts = _allProducts.where((p) => !p.isAvailable).toList();
      notifyListeners();
    }
    return success;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
