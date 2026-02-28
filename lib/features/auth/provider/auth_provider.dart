import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _error;
  String? _userRole;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userRole => _userRole;

  String? _phoneNumber;

  Future<bool> checkUserRole({
    required String phone,
    required String selectedRole,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

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

    return true;
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
