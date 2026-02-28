import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/entry/store/presentation/provider/entry_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/my_cart_order_screen.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/shop_home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EntryProvider>(
          create: (context) => EntryProvider(),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // home: RoleSelect()
      home: ShopHomeScreen(),
    );
  }
}
