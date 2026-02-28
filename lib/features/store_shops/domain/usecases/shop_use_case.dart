import '../../domain/entities/shop.dart';
import '../../domain/repositories/shop_repository.dart';

class ShopUseCase {
  final ShopRepository repository;

  ShopUseCase(this.repository);

  Future<List<Shop>> getShopsByStore(String storeId) {
    return repository.getShopsByStore(storeId);
  }

  Future<Shop?> getShopById(String storeId, String shopId) {
    return repository.getShopById(storeId, shopId);
  }

  Future<Shop?> getShopByPhone(String phone) {
    return repository.getShopByPhone(phone);
  }

  Future<String> addShop(Shop shop) {
    return repository.addShop(shop);
  }

  Future<void> updateShop(Shop shop) {
    return repository.updateShop(shop);
  }

  Future<void> deleteShop(String storeId, String shopId) {
    return repository.deleteShop(storeId, shopId);
  }

  Future<void> toggleShopStatus(String storeId, String shopId, bool isActive) {
    return repository.toggleShopStatus(storeId, shopId, isActive);
  }
}
