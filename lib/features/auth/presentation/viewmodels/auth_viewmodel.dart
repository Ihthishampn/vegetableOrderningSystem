import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class serves as the view model for authentication-related UI.
///
/// It currently contains the same logic that used to live in
/// `features/auth/provider/auth_provider.dart`.  The plan is to keep this
/// class lean and move Firestore/HTTP calls into the data layer (e.g. a
/// repository or remote datasource) once the feature is further refactored.
///
/// The UI widgets should never import or depend on Firestore directly; they
/// should interact only with the methods and properties provided here.
class AuthViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _error;
  String? _userRole;
  String? _userId;
  String? _storeId;
  String? _storeName; // name pulled from users collection during store login

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userRole => _userRole;
  String? get userId => _userId;
  String? get uid => _userId; // alias for convenience
  String? get storeId => _storeId;
  String? get storeName => _storeName;
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  /// Checks whether a user with the given phone number exists and matches the
  /// selected role ("store" or "shop").  This is the same logic that used to
  /// exist in [auth_provider].  In a future refactor it should be pushed down
  /// to a repository.
  Future<bool> checkUserRole({
    required String phone,
    required String selectedRole,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (selectedRole == 'shop') {
        final cleanPhone = phone.replaceAll('+', '');
        final shopQuery = await _firestore
            .collection('shops')
            .where('phone', isEqualTo: cleanPhone)
            .limit(1)
            .get();

        if (shopQuery.docs.isEmpty) {
          _error = "No shop found with this phone number";
          _isLoading = false;
          notifyListeners();
          return false;
        }

        final data = shopQuery.docs.first.data();
        final shopId = shopQuery.docs.first.id;

        // Check if the shop is active
        final isActive = data['isActive'] ?? true;
        if (!isActive) {
          _error =
              "This shop has been deactivated by the store. Please contact them.";
          _isLoading = false;
          notifyListeners();
          return false;
        }

        _phoneNumber = phone;
        _userRole = 'shop';
        _userId = shopId;
        _storeId = data['storeId'] ?? shopId;
        _storeName = data['shopName'] ?? '';

        _isLoading = false;
        notifyListeners();
        return true;
      }

      final query = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (query.docs.isEmpty) {
        _error = "Account not found";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final data = query.docs.first.data();
      final dbRole = data['role'];

      if (dbRole != selectedRole) {
        _error = "You are not registered as $selectedRole";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _phoneNumber = phone;
      _userRole = dbRole;
      _userId = query.docs.first.id;
      _storeId = data['storeId'] ?? _userId;
      _storeName = data['storename'] ?? '';

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

  Future<bool> verifyOtp(String otp) async {
    if (otp != "123456") {
      _error = "Incorrect OTP";
      notifyListeners();
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("role", _userRole ?? "");
    await prefs.setString("phone", _phoneNumber ?? "");
    await prefs.setString("userId", _userId ?? "");
    await prefs.setString("storeId", _storeId ?? "");
    if (_storeName != null) {
      await prefs.setString("storename", _storeName!);
    }

    return true;
  }

  Future<void> restoreAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

      if (isLoggedIn) {
        _userRole = prefs.getString("role");
        _phoneNumber = prefs.getString("phone");
        _userId = prefs.getString("userId");
        _storeId = prefs.getString("storeId");
        _storeName = prefs.getString("storename");
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
