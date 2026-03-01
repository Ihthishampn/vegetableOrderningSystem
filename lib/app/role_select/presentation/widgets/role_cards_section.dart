import 'package:flutter/material.dart';
import 'role_card.dart';

class RoleCardsSection extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String> onRoleSelected;

  const RoleCardsSection({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleCard(
          role: 'store',
          title: 'Continue as Store',
          subtitle:
              'Manage inventory, staff, and distribute vegetables to shops.',
          icon: Icons.storefront_rounded,
          color: const Color(0xFF4C78FF),
          isSelected: selectedRole == 'store',
          onTap: () => onRoleSelected('store'),
        ),
        const SizedBox(height: 20),
        RoleCard(
          role: 'shop',
          title: 'Continue as Shop',
          subtitle: 'Order fresh vegetables and manage retail sales.',
          icon: Icons.shopping_bag_outlined,
          color: const Color(0xFF00C566),
          isSelected: selectedRole == 'shop',
          onTap: () => onRoleSelected('shop'),
        ),
      ],
    );
  }
}
