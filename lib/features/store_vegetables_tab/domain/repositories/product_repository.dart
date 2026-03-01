import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsByStore(String storeId);

  Future<Product?> getProductById(String storeId, String productId);

  Future<String> addProduct(Product product);

  Future<void> updateProduct(Product product);

  Future<void> deleteProduct(String storeId, String productId);

  Future<List<Product>> getProductsByAvailability(
    String storeId,
    bool isAvailable,
  );
}
