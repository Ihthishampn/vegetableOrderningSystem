import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ProductUseCase {
  final ProductRepository repository;

  ProductUseCase(this.repository);

  Future<List<Product>> getProducts(String storeId) {
    return repository.getProductsByStore(storeId);
  }

  Future<Product?> getProduct(String storeId, String productId) {
    return repository.getProductById(storeId, productId);
  }

  Future<String> addProduct(Product product) {
    return repository.addProduct(product);
  }

  Future<void> updateProduct(Product product) {
    return repository.updateProduct(product);
  }

  Future<void> deleteProduct(String storeId, String productId) {
    return repository.deleteProduct(storeId, productId);
  }

  Future<List<Product>> getAvailableProducts(String storeId) {
    return repository.getProductsByAvailability(storeId, true);
  }

  Future<List<Product>> getUnavailableProducts(String storeId) {
    return repository.getProductsByAvailability(storeId, false);
  }
}
