import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/app/role_slect.dart';

class StoreLogoutButton extends StatelessWidget {
  const StoreLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final auth = context.read<AuthProvider>();
        await auth.logout();

        if (!context.mounted) return;

        // Navigate back to RoleSelect
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RoleSelect()),
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF8F9FA),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Log out",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.logout, color: Colors.red, size: 18),
        ],
      ),
    );
  }
}
