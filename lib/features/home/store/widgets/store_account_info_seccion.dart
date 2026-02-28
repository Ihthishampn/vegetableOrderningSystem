
import 'package:flutter/material.dart';

import 'store_info_tile.dart';

class StoreAccountInfoSection extends StatelessWidget {
  const StoreAccountInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shield_outlined, size: 20),
              SizedBox(width: 10),
              Text(
                "Account Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const StoreInfoTile(
            icon: Icons.person_outline,
            label: "Shop Owner Name",
            value: "John Smith",
          ),
          const SizedBox(height: 15),
          const StoreInfoTile(
            icon: Icons.phone_outlined,
            label: "Registered Mobile",
            value: "+91 98765 43234",
          ),
        ],
      ),
    );
  }
}
