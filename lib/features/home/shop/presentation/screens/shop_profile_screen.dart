import 'package:flutter/material.dart';

import '../widgets/shop_profile/shop_info_tile.dart';
import '../widgets/shop_profile/shop_profile_header.dart';
import '../widgets/shop_profile/shop_profile_log_out_button.dart';
import '../widgets/shop_profile/shop_profile_seccion_header.dart';
import '../widgets/shop_profile/shop_profile_staff_managment_title.dart';

class ShopProfileScreen extends StatelessWidget {
  const ShopProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
            const ShopInfoTile(
              icon: Icons.store_outlined,
              iconColor: Colors.purple,
              label: "Shop Name",
              value: "Green Valley Grocery",
            ),
            const ShopInfoTile(
              icon: Icons.person_outline,
              iconColor: Colors.green,
              label: "Shop Owner Name",
              value: "John Smith",
            ),
            const ShopInfoTile(
              icon: Icons.phone_outlined,
              iconColor: Colors.blue,
              label: "Registered Mobile",
              value: "+91 98765 43234",
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
      ),
    );
  }
}

