import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/shop_card.dart';
import '../../pages/add_shop_page.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_shops/presentation/provider/shop_provider.dart';
import 'package:vegetable_ordering_system/features/store_shops/domain/entities/shop.dart';

class ShopsManagmentScreen extends StatefulWidget {
  const ShopsManagmentScreen({super.key});

  @override
  State<ShopsManagmentScreen> createState() => _ShopsManagmentScreenState();
}

class _ShopsManagmentScreenState extends State<ShopsManagmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthViewModel>(context, listen: false);
      final shopProv = Provider.of<ShopProvider>(context, listen: false);
      if (auth.uid != null) {
        shopProv.initialize(auth.uid!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shops Management',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddShopPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ShopProvider>(
        builder: (context, shopProv, _) {
          if (shopProv.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final shops = shopProv.shopList;
          if (shops.isEmpty) {
            return const Center(child: Text('No shops yet.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              itemCount: shops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final Shop shop = shops[index];
                return ShopCard(shop: shop);
              },
            ),
          );
        },
      ),
    );
  }
}
