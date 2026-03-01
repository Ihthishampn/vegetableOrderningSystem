import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/providers/role_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/widgets/role_card.dart';
import 'package:vegetable_ordering_system/features/auth/auth_shop/presentation/screens/login_screen_shop.dart';
import 'package:vegetable_ordering_system/features/auth/auth_store/presentation/screens/store_login_screen.dart';


class RoleSelect extends StatelessWidget {
  const RoleSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoleProvider>(
      create: (_) => RoleProvider(),
      child: const _RoleSelectView(),
    );
  }
}

class _RoleSelectView extends StatelessWidget {
  const _RoleSelectView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoleProvider>();
    final selectedRole = provider.selectedRole;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2926),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please select how you would like to\ncontinue using the app",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 50),

              RoleCard(
                role: 'store',
                title: 'Continue as Store',
                subtitle:
                    'Manage inventory, staff, and distribute vegetables to shops.',
                icon: Icons.storefront_rounded,
                color: const Color(0xFF4C78FF),
                isSelected: selectedRole == 'store',
                onTap: () => provider.selectRole('store'),
              ),
              const SizedBox(height: 20),
              RoleCard(
                role: 'shop',
                title: 'Continue as Shop',
                subtitle: 'Order fresh vegetables and manage retail sales.',
                icon: Icons.shopping_bag_outlined,
                color: const Color(0xFF00C566),
                isSelected: selectedRole == 'shop',
                onTap: () => provider.selectRole('shop'),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: selectedRole == null
                      ? null
                      : () {
                          if (selectedRole == 'store') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StoreLoginScreen(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreenShop(),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2926),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
