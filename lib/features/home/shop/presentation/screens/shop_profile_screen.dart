import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
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
    // Get shop ID from auth (userId is shopId for shops)
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final storeId = auth.storeId;
    final shopId = auth.userId;

    // Fetch shop data when screen loads
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
        toolbarHeight: 120,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                //   Profile Card
                const ProfileHeaderCard(),

                const SizedBox(height: 24),

                //  Account  Section
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

                const SizedBox(height: 24),

                // Staff Management Section
                const ShopProfileSeccionHeader(title: "Staff Management"),
                const StaffManagementTile(),

                const SizedBox(height: 40),

                const ShopProfileLogOutButton(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
