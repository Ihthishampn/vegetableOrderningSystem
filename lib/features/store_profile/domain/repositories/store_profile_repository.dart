import '../entities/store_profile.dart';

abstract class StoreProfileRepository {
  Future<StoreProfile?> getStoreProfileByUserId(String userId);
  Future<void> updateStoreProfile(StoreProfile storeProfile);
  Future<void> createStoreProfile(StoreProfile storeProfile);
}
