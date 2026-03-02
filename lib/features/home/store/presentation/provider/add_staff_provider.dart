import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_staff/domain/entities/staff.dart';
import 'package:vegetable_ordering_system/features/store_staff/presentation/provider/staff_provider.dart';

class AddStaffProvider extends ChangeNotifier {
  final StaffProvider staffProvider;
  final AuthViewModel auth;
  final Staff? staff;

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController positionController;
  final TextEditingController addressController;
  DateTime? dateOfJoining;

  bool isLoading = false;
  bool canSubmit = false;
  String? lastError;

  AddStaffProvider({
    required this.staffProvider,
    required this.auth,
    this.staff,
  }) : nameController = TextEditingController(text: staff?.name ?? ''),
       phoneController = TextEditingController(text: staff?.phone ?? ''),
       emailController = TextEditingController(text: staff?.email ?? ''),
       positionController = TextEditingController(text: staff?.position ?? ''),
       addressController = TextEditingController(text: staff?.address ?? '') {
    dateOfJoining = staff?.dateOfJoining;

    nameController.addListener(_onControllersChanged);
    phoneController.addListener(_onControllersChanged);
    emailController.addListener(_onControllersChanged);
    positionController.addListener(_onControllersChanged);
    addressController.addListener(_onControllersChanged);
    _onControllersChanged();
  }

  void _onControllersChanged() {
    final newCan =
        nameController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        positionController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        dateOfJoining != null;

    if (newCan != canSubmit) {
      canSubmit = newCan;
      notifyListeners();
    }
  }

  void setCanSubmit(bool value) {
    if (canSubmit != value) {
      canSubmit = value;
      notifyListeners();
    }
  }

  void setDate(DateTime d) {
    dateOfJoining = d;
    _onControllersChanged();
  }

  Future<bool> submit(BuildContext context) async {
    if (auth.uid == null) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;

    final now = DateTime.now();

    try {
      isLoading = true;
      notifyListeners();

      final newStaff = Staff(
        id: staff?.id ?? '',
        storeId: auth.uid!,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        position: positionController.text.trim(),
        address: addressController.text.trim(),
        idProof: staff?.idProof,
        dateOfJoining: dateOfJoining ?? now,
        isActive: staff?.isActive ?? true,
        createdAt: staff?.createdAt ?? now,
        updatedAt: now,
      );

      final success = staff == null
          ? await staffProvider.addStaff(newStaff)
          : await staffProvider.updateStaff(newStaff);

      isLoading = false;
      notifyListeners();

      if (success) {
        lastError = null;
      }

      return success;
    } catch (e) {
      isLoading = false;
      lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.removeListener(_onControllersChanged);
    phoneController.removeListener(_onControllersChanged);
    emailController.removeListener(_onControllersChanged);
    positionController.removeListener(_onControllersChanged);
    addressController.removeListener(_onControllersChanged);
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    positionController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
