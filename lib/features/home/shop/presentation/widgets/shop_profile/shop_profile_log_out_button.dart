import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/app/role_slect.dart';

class ShopProfileLogOutButton extends StatelessWidget {
  const ShopProfileLogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final auth = context.read<AuthProvider>();
            await auth.logout();

            if (!context.mounted) return;

            // Navigate back to RoleSelect
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const RoleSelect()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Colors.red, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Logout",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
