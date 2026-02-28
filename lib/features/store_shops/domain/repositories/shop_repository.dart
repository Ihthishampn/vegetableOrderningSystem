import '../entities/shop.dart';

abstract class ShopRepository {
  Future<List<Shop>> getShopsByStore(String storeId);
  Future<Shop?> getShopById(String storeId, String shopId);
  Future<Shop?> getShopByPhone(String phone);
  Future<String> addShop(Shop shop);
  Future<void> updateShop(Shop shop);
  Future<void> deleteShop(String storeId, String shopId);
  Future<void> toggleShopStatus(String storeId, String shopId, bool isActive);
}
