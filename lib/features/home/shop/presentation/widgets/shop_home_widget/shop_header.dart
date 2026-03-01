import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/my_cart_order_screen.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';

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
            Consumer<AuthViewModel>(
              builder: (context, auth, _) {
                final shopName = auth.storeName?.isNotEmpty == true
                    ? auth.storeName!
                    : 'Store';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shopName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Fresh Vegetables Store",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                );
              },
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
          right: 0,
          top: 0,
          child: Consumer<CartProvider>(
            builder: (context, cart, _) {
              final count = cart.totalQuantity;
              if (count <= 0) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
