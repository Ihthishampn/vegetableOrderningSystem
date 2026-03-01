import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';

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
          // Try fetching name/phone from AuthProvider (which reads 'users' doc)
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final name = auth.storeName?.isNotEmpty == true
                  ? auth.storeName!
                  : 'Not set';
              final phone = auth.phoneNumber?.isNotEmpty == true
                  ? auth.phoneNumber!
                  : 'Not set';
              return Column(
                children: [
                  StoreInfoTile(
                    icon: Icons.person_outline,
                    label: "Shop Owner Name",
                    value: name,
                  ),
                  const SizedBox(height: 15),
                  StoreInfoTile(
                    icon: Icons.phone_outlined,
                    label: "Registered Mobile",
                    value: phone,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
