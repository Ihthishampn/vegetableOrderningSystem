import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_shops/domain/entities/shop.dart';
import 'package:vegetable_ordering_system/features/store_shops/presentation/provider/shop_provider.dart';

class AddShopProvider extends ChangeNotifier {
  final ShopProvider shopProvider;
  final AuthViewModel auth;
  final Shop? shop;

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController;
  final TextEditingController managerController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;

  bool isLoading = false;
  bool canSubmit = false;
  String? lastError;

  AddShopProvider({required this.shopProvider, required this.auth, this.shop})
    : nameController = TextEditingController(text: shop?.shopName ?? ''),
      managerController = TextEditingController(text: shop?.managerName ?? ''),
      phoneController = TextEditingController(
        text: _initialPhoneValue(shop?.phone),
      ),
      addressController = TextEditingController(text: shop?.address ?? ''),
      cityController = TextEditingController(text: shop?.city ?? '') {
    // Recalculate canSubmit when controllers change
    nameController.addListener(_onControllersChanged);
    managerController.addListener(_onControllersChanged);
    phoneController.addListener(_onControllersChanged);
    addressController.addListener(_onControllersChanged);
    cityController.addListener(_onControllersChanged);
    _onControllersChanged();
  }

  static String _initialPhoneValue(String? fullPhone) {
    if (fullPhone == null || fullPhone.isEmpty) return '';
    if (fullPhone.startsWith('91')) return fullPhone.substring(2);
    return fullPhone;
  }

  void _onControllersChanged() {
    final newCan =
        nameController.text.trim().isNotEmpty &&
        managerController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        cityController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty;
    if (newCan != canSubmit) {
      canSubmit = newCan;
      notifyListeners();
    }
  }

  void setCanSubmit(bool val) {
    if (canSubmit != val) {
      canSubmit = val;
      notifyListeners();
    }
  }

  Future<bool> submit(BuildContext context) async {
    if (auth.uid == null) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;

    final entered = phoneController.text.trim();
    final phoneToCheck = '91' + entered;

    // Check for duplicates in Firestore
    try {
      isLoading = true;
      notifyListeners();

      if (shop == null) {
        final existingShop = await FirebaseFirestore.instance
            .collection('shops')
            .where('phone', isEqualTo: phoneToCheck)
            .limit(1)
            .get();
        if (existingShop.docs.isNotEmpty) {
          isLoading = false;
          lastError = 'A shop with this phone number already exists';
          notifyListeners();
          return false;
        }
      } else if (shop?.phone != phoneToCheck) {
        final existingShop = await FirebaseFirestore.instance
            .collection('shops')
            .where('phone', isEqualTo: phoneToCheck)
            .limit(1)
            .get();
        if (existingShop.docs.isNotEmpty) {
          isLoading = false;
          lastError = 'A shop with this phone number already exists';
          notifyListeners();
          return false;
        }
      }

      final now = DateTime.now();
      final newShop = Shop(
        id: shop?.id ?? '',
        storeId: auth.uid!,
        shopName: nameController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        phone: phoneToCheck,
        managerName: managerController.text.trim(),
        createdAt: shop?.createdAt ?? now,
        updatedAt: now,
        isActive: shop?.isActive ?? true,
      );

      final success = shop == null
          ? await shopProvider.addShop(newShop)
          : await shopProvider.updateShop(newShop);

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
    managerController.removeListener(_onControllersChanged);
    phoneController.removeListener(_onControllersChanged);
    addressController.removeListener(_onControllersChanged);
    cityController.removeListener(_onControllersChanged);
    nameController.dispose();
    managerController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.dispose();
  }
}
