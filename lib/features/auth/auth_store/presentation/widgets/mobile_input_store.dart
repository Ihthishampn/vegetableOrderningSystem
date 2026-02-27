

import 'package:flutter/material.dart';

class MobileInput extends StatelessWidget {
  const MobileInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Mobile Number",
          hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF707070)),
          prefixIcon: const Icon(Icons.phone_outlined, size: 18),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}