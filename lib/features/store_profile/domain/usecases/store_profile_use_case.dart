import '../../domain/entities/store_profile.dart';
import '../../domain/repositories/store_profile_repository.dart';

class StoreProfileUseCase {
  final StoreProfileRepository repository;

  StoreProfileUseCase(this.repository);

  Future<StoreProfile?> getStoreProfileByUserId(String userId) {
    return repository.getStoreProfileByUserId(userId);
  }

  Future<void> updateStoreProfile(StoreProfile storeProfile) {
    return repository.updateStoreProfile(storeProfile);
  }

  Future<void> createStoreProfile(StoreProfile storeProfile) {
    return repository.createStoreProfile(storeProfile);
  }
}
