import 'package:flutter/material.dart';

/// Keeps track of the currently entered OTP digits.
///
/// The verification sheet listens to this provider and rebuilds the circle
/// indicators whenever the value changes, removing the need for `setState`
/// inside the sheet itself.
class OtpProvider extends ChangeNotifier {
  String _otp = '';

  String get otp => _otp;

  void updateOtp(String value) {
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
