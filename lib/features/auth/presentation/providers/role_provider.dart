import 'package:flutter/material.dart';

/// Simple provider that holds the currently selected user role ("store" or "shop").
///
/// Used by the role selection screen so that the UI can be rebuilt via
/// [ChangeNotifier] instead of calling `setState` directly.
class RoleProvider extends ChangeNotifier {
  String? _selectedRole;

  String? get selectedRole => _selectedRole;

  void selectRole(String role) {
    if (_selectedRole == role) return;
    _selectedRole = role;
    notifyListeners();
  }
}
