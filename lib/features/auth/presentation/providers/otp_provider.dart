import 'package:flutter/material.dart';


class OtpProvider extends ChangeNotifier {
  String _otp = '';

  String get otp => _otp;

  void updateOtp(String value) {
    if (value.length > 6) {
      value = value.substring(0, 6);
    }
    if (_otp == value) return;
    _otp = value;
    notifyListeners();
  }

  void clear() {
    if (_otp.isEmpty) return;
    _otp = '';
    notifyListeners();
  }
}
