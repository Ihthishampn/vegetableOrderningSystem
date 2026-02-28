import '../entities/staff.dart';

abstract class StaffRepository {
  Future<List<Staff>> getStaffByStore(String storeId);
  Future<Staff?> getStaffById(String storeId, String staffId);
  Future<String> addStaff(Staff staff);
  Future<void> updateStaff(Staff staff);
  Future<void> deleteStaff(String storeId, String staffId);
  Future<void> toggleStaffStatus(String storeId, String staffId, bool isActive);
}
