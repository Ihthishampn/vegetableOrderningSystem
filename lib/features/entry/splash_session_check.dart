import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role');

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
