import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/my_cart_order_screen.dart';

import '../../../../store/widgets/top_curve_clipper.dart' show TopCurveClipper;
import '../../screens/shop_profile_screen.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopCurveClipper(),
      child: Container(
        height: 130,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        decoration: const BoxDecoration(color: Color(0xFF5C79FF)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Green Valley Grocery",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Fresh Vegetables Store",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                _buildCartBadge(context),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShopProfileScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartBadge(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MyCartOrdersScreen()),
            );
          },
          icon: Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '5',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
