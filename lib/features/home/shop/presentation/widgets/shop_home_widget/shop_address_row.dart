import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';

class ShopAddressRow extends StatelessWidget {
  final String storeNameFromFirebase;

  const ShopAddressRow({super.key, required this.storeNameFromFirebase});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<StoreProfileProvider>(context, listen: false);
    final storeName = storeNameFromFirebase.isNotEmpty
        ? storeNameFromFirebase
        : (profile.storeProfile?.storeName ?? 'Your Store');
    final address = profile.storeProfile?.address;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            address != null && address.isNotEmpty
                ? '$storeName, $address'
                : storeName,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'You have already selected a store. You cannot change the store right now.',
                ),
              ),
            );
          },
          child: const Text(
            "Change store",
            style: TextStyle(color: Color(0xFF5C79FF)),
          ),
        ),
      ],
    );
  }
}
