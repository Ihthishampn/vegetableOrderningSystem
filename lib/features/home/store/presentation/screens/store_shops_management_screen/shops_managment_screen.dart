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
          'Shops',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Consumer<ShopProvider>(
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
                  
                  separatorBuilder: (_, unused) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final Shop shop = shops[index];
                    return ShopCard(shop: shop);
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddShopPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2926),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "+ Add New Shop",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
