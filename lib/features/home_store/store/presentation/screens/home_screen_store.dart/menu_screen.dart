import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home_store/store/presentation/screens/sales_report_screen.dart/sales_report_screen.dart';
import 'package:vegetable_ordering_system/features/home_store/store/presentation/screens/shops_management_screen/shops_managment_screen.dart';
import 'package:vegetable_ordering_system/features/home_store/store/presentation/screens/staff_managment/staff_management_screen.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Menu",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // 1. Staff Management Tile
            _buildMenuTile(
              context,
              icon: Icons.people_outline,
              title: "Staff Management",
              subtitle: "Add, view, and manage staffs",
              onTap: () {
                // Navigate to Staff Management
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StaffManagementScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // 2. Shops Tile
            _buildMenuTile(
              context,
              icon: Icons.storefront_outlined,
              title: "Shops",
              subtitle: "Add, view, and manage shops",
              onTap: () {
                // Navigate to Shops
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShopsManagmentScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // 3. Sales Reports Tile
            _buildMenuTile(
              context,
              icon: Icons.description_outlined,
              title: "Sales Reports",
              subtitle: "View sales report",
              onTap: () {
                // Navigate to Sales Reports
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SalesReportScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA), // Very light grey background
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black87, size: 24),
            ),
            const SizedBox(width: 16),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Trailing Chevron
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
