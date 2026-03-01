import 'package:flutter/material.dart';
import 'store_shops_identify.dart';

class StoreProfileIdentityCard extends StatelessWidget {
  const StoreProfileIdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 110,
      left: 20,
      right: 20,
      child: const ShopIdentityCard(),
    );
  }
}
