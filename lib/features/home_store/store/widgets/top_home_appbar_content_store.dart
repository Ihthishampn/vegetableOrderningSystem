
import 'package:flutter/material.dart';

import 'top_curve_clipper.dart';

class TopAppBarContent extends StatelessWidget {
  final Size size;
  const TopAppBarContent({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopCurveClipper(),
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFF2F2929)),
        child: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.05,
            left: size.width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                "Green Valley Grocery",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Fresh Vegetable Store",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: size.height * 0.017,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}