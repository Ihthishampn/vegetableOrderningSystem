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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth > 600 ? screenWidth * 0.05 : 16.0;
    final separatorHeight = screenHeight > 800 ? 16.0 : 12.0;
    final buttonHeight = screenHeight > 800 ? 65.0 : 55.0;
    final titleFontSize = screenWidth > 600 ? 22.0 : 20.0;
    final buttonFontSize = screenWidth > 600 ? 18.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shops',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Selector<ShopProvider, bool>(
            selector: (_, p) => p.isLoading,
            builder: (context, isLoading, _) {
              if (isLoading) return const Center(child: CircularProgressIndicator());
              return Selector<ShopProvider, int>(
                selector: (_, p) => p.shopList.length,
                builder: (context, length, _) {
                  if (length == 0) return const Center(child: Text('No shops yet.'));
                  return Padding(
                    padding: EdgeInsets.all(padding),
                    child: ListView.separated(
                      itemCount: length,
                      separatorBuilder: (_, unused) => SizedBox(height: separatorHeight),
                      itemBuilder: (context, index) {
                        return Selector<ShopProvider, Shop?>(
                          selector: (_, p) => p.shopList.length > index ? p.shopList[index] : null,
                          builder: (context, shop, __) {
                            if (shop == null) return const SizedBox.shrink();
                            return ShopCard(key: ValueKey(shop.id), shop: shop);
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(padding),
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
                  minimumSize: Size(double.infinity, buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "+ Add New Shop",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: buttonFontSize,
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
