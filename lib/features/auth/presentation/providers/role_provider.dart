import 'package:flutter/material.dart';


class RoleProvider extends ChangeNotifier {
  String? _selectedRole;

  String? get selectedRole => _selectedRole;

  void selectRole(String role) {
    if (_selectedRole == role) return;
    _selectedRole = role;
    notifyListeners();
  }
}
