import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_shops/presentation/provider/shop_provider.dart';

import '../widgets/shop_profile/shop_info_tile.dart';
import '../widgets/shop_profile/shop_profile_header.dart';
import '../widgets/shop_profile/shop_profile_log_out_button.dart';
import '../widgets/shop_profile/shop_profile_seccion_header.dart';
import '../widgets/shop_profile/shop_profile_staff_managment_title.dart';

class ShopProfileScreen extends StatelessWidget {
  const ShopProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight > 800 ? 140.0 : 120.0;
    final titleFontSize = screenWidth > 600 ? 22.0 : 20.0;
    final iconSize = screenWidth > 600 ? 24.0 : 20.0;
    final sectionSpacing = screenHeight > 800 ? 28.0 : 24.0;
    final bottomSpacing = screenHeight > 800 ? 48.0 : 40.0;

    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final storeId = auth.storeId;
    final shopId = auth.userId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (storeId != null && shopId != null) {
        Provider.of<ShopProvider>(
          context,
          listen: false,
        ).fetchShopById(storeId, shopId);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A68FF),
        elevation: 0,
        toolbarHeight: appBarHeight,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: iconSize),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ShopProvider>(
        builder: (context, shopProvider, _) {
          if (shopProvider.isLoadingSingleShop) {
            return const Center(child: CircularProgressIndicator());
          }

          if (shopProvider.errorSingleShop != null) {
            return Center(
              child: Text('Error: ${shopProvider.errorSingleShop}'),
            );
          }

          final shop = shopProvider.currentShop;
          if (shop == null) {
            return const Center(child: Text('Shop data not found'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const ProfileHeaderCard(),

                SizedBox(height: sectionSpacing),

                const ShopProfileSeccionHeader(
                  icon: Icons.shield_outlined,
                  title: "Account Information",
                ),
                ShopInfoTile(
                  icon: Icons.store_outlined,
                  iconColor: Colors.purple,
                  label: "Shop Name",
                  value: shop.shopName,
                ),
                ShopInfoTile(
                  icon: Icons.person_outline,
                  iconColor: Colors.green,
                  label: "Shop Owner Name",
                  value: shop.managerName ?? "N/A",
                ),
                ShopInfoTile(
                  icon: Icons.phone_outlined,
                  iconColor: Colors.blue,
                  label: "Registered Mobile",
                  value: shop.phone,
                ),
                ShopInfoTile(
                  icon: Icons.location_on_outlined,
                  iconColor: Colors.red,
                  label: "Location",
                  value: "${shop.address}, ${shop.city}",
                ),

                SizedBox(height: sectionSpacing),

                const ShopProfileSeccionHeader(title: "Staff Management"),
                const StaffManagementTile(),

                SizedBox(height: bottomSpacing),

                const ShopProfileLogOutButton(),
                SizedBox(height: sectionSpacing * 0.5),
              ],
            ),
          );
        },
      ),
    );
  }
}
