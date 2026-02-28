import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _error;
  String? _userRole;
  String? _userId;
  String? _storeId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userRole => _userRole;
  String? get userId => _userId;
  String? get uid => _userId; // Alias for userId - Firebase UID
  String? get storeId => _storeId;

  /// Phone number used during login (if any)
  String? get phoneNumber => _phoneNumber;

  String? _phoneNumber;

  Future<bool> checkUserRole({
    required String phone,
    required String selectedRole,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // For shop login, check the shops collection for the phone number
      if (selectedRole == 'shop') {
        final shopQuery = await _firestore
            .collection('shops')
            .where('phone', isEqualTo: phone)
            .limit(1)
            .get();

        if (shopQuery.docs.isEmpty) {
          _error = "No shop found with this phone number";
          _isLoading = false;
          notifyListeners();
          return false;
        }

        final shopData = shopQuery.docs.first.data();
        final shopId = shopQuery.docs.first.id;

        _phoneNumber = phone;
        _userRole = 'shop';
        _userId = shopId; // Use shopId as userId for shops
        _storeId = shopData['storeId'] ?? shopId;

        _isLoading = false;
        notifyListeners();
        return true;
      }

      // For store login, check the users collection
      final query = await _firestore
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();

      if (query.docs.isEmpty) {
        _error = "Account not found";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final data = query.docs.first.data();
      final dbRole = data["role"];

      if (dbRole != selectedRole) {
        _error = "You are not registered as $selectedRole";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _phoneNumber = phone;
      _userRole = dbRole;
      _userId = query.docs.first.id;
      _storeId = data["storeId"] ?? _userId;

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

    return true;
  }

  /// Restore authentication state from SharedPreferences (call on app startup)
  Future<void> restoreAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

      if (isLoggedIn) {
        _userRole = prefs.getString("role");
        _phoneNumber = prefs.getString("phone");
        _userId = prefs.getString("userId");
        _storeId = prefs.getString("storeId");
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

  /// Clears the last error message (used by UI when user modifies input).
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
