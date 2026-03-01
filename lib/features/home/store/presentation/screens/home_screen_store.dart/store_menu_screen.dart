import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/store_shops_management_screen/shops_managment_screen.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/store_staff_management_screen/staff_managment_screen.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/store_sales_report_screen.dart/sales_report_screen.dart';
import '../../../widgets/menu_tile.dart';

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
            MenuTile(
              icon: Icons.people_outline,
              title: "Staff Management",
              subtitle: "Add, view, and manage staffs",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StaffManagementScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            MenuTile(
              icon: Icons.storefront_outlined,
              title: "Shops",
              subtitle: "Add, view, and manage shops",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShopsManagmentScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            MenuTile(
              icon: Icons.description_outlined,
              title: "Sales Reports",
              subtitle: "View sales report",
              onTap: () {
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
}
