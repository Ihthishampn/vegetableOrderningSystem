import '../entities/product.dart';

/// Abstract repository contract for product operations.
abstract class ProductRepository {
  /// Fetch all products for a store.
  Future<List<Product>> getProductsByStore(String storeId);

  /// Fetch a single product by ID.
  Future<Product?> getProductById(String storeId, String productId);

  /// Add a new product.
  Future<String> addProduct(Product product);

  /// Update an existing product.
  Future<void> updateProduct(Product product);

  /// Delete a product.
  Future<void> deleteProduct(String storeId, String productId);

  /// Get products by availability status.
  Future<List<Product>> getProductsByAvailability(
    String storeId,
    bool isAvailable,
  );
}
