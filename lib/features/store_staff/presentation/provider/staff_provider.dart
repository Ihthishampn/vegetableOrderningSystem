import 'package:flutter/material.dart';
import '../../domain/entities/staff.dart';
import '../../domain/usecases/staff_use_case.dart';

class StaffProvider with ChangeNotifier {
  final StaffUseCase _useCase;

  StaffProvider(this._useCase);

  List<Staff> _staffList = [];
  bool _isLoading = false;
  String? _error;
  String? _storeId;

  List<Staff> get staffList => _staffList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize(String storeId) async {
    _storeId = storeId;
    await fetchStaff();
  }

  Future<void> fetchStaff() async {
    if (_storeId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _staffList = await _useCase.getStaffByStore(_storeId!);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addStaff(Staff staff) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final id = await _useCase.addStaff(staff);
      _staffList.add(staff.copyWith(id: id));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStaff(Staff staff) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _useCase.updateStaff(staff);
      final index = _staffList.indexWhere((s) => s.id == staff.id);
      if (index != -1) {
        _staffList[index] = staff;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteStaff(String staffId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _useCase.deleteStaff(_storeId!, staffId);
      _staffList.removeWhere((s) => s.id == staffId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleStaffStatus(String staffId, bool isActive) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _useCase.toggleStaffStatus(_storeId!, staffId, isActive);
      final index = _staffList.indexWhere((s) => s.id == staffId);
      if (index != -1) {
        _staffList[index] = _staffList[index].copyWith(isActive: isActive);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
