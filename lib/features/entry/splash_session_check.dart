import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/screens/role_select.dart';
import 'package:vegetable_ordering_system/features/entry/store/presentation/nav_bar_store/store_entry.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/shop_home_screen.dart';

class SplashSessionCheck extends StatefulWidget {
  const SplashSessionCheck({super.key});

  @override
  State<SplashSessionCheck> createState() => _SplashSessionCheckState();
}

class _SplashSessionCheckState extends State<SplashSessionCheck> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role');

    if (!mounted) return;

    final authProvider = context.read<AuthViewModel>();

    if (isLoggedIn && role != null) {
      await authProvider.restoreAuthState();
    }

    if (!mounted) return;

    if (isLoggedIn && role != null) {
      late Widget homeScreen;
      if (role == 'store') {
        homeScreen = const StoreEntry();
      } else if (role == 'shop') {
        homeScreen = const ShopHomeScreen();
      } else {
        homeScreen = const RoleSelect();
      }

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => homeScreen));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const RoleSelect()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_bg.png',
              width: 550,
              height: 550,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
          
          ],
        ),
      ),
    );
  }
}
