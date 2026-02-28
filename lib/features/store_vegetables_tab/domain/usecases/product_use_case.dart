import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use-case for managing products.
class ProductUseCase {
  final ProductRepository repository;

  ProductUseCase(this.repository);

  /// Get all products for a store.
  Future<List<Product>> getProducts(String storeId) {
    return repository.getProductsByStore(storeId);
  }

  /// Get a single product.
  Future<Product?> getProduct(String storeId, String productId) {
    return repository.getProductById(storeId, productId);
  }

  /// Add a new product.
  Future<String> addProduct(Product product) {
    return repository.addProduct(product);
  }

  /// Update a product.
  Future<void> updateProduct(Product product) {
    return repository.updateProduct(product);
  }

  /// Delete a product.
  Future<void> deleteProduct(String storeId, String productId) {
    return repository.deleteProduct(storeId, productId);
  }

  /// Get available products only.
  Future<List<Product>> getAvailableProducts(String storeId) {
    return repository.getProductsByAvailability(storeId, true);
  }

  /// Get unavailable products only.
  Future<List<Product>> getUnavailableProducts(String storeId) {
    return repository.getProductsByAvailability(storeId, false);
  }
}
