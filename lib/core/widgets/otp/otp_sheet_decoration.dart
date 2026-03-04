import 'package:flutter/material.dart';

class OtpSheetDecoration {
  static BoxDecoration getDecoration(bool isStore) {
    if (isStore) {
      return const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Colors.white,
      );
    } else {
      return const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD4DCFF), Colors.white],
          stops: [0.0, 0.16],
        ),
      );
    }
  }

  static Color getButtonColor(bool isStore) {
    return isStore ? const Color(0xFF2D2926) : const Color(0xFF5C79FF);
  }
}
