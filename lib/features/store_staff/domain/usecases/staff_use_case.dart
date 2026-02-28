import '../../domain/entities/staff.dart';
import '../../domain/repositories/staff_repository.dart';

class StaffUseCase {
  final StaffRepository repository;

  StaffUseCase(this.repository);

  Future<List<Staff>> getStaffByStore(String storeId) {
    return repository.getStaffByStore(storeId);
  }

  Future<Staff?> getStaffById(String storeId, String staffId) {
    return repository.getStaffById(storeId, staffId);
  }

  Future<String> addStaff(Staff staff) {
    return repository.addStaff(staff);
  }

  Future<void> updateStaff(Staff staff) {
    return repository.updateStaff(staff);
  }

  Future<void> deleteStaff(String storeId, String staffId) {
    return repository.deleteStaff(storeId, staffId);
  }

  Future<void> toggleStaffStatus(
    String storeId,
    String staffId,
    bool isActive,
  ) {
    return repository.toggleStaffStatus(storeId, staffId, isActive);
  }
}
