import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/store_shops_management_screen/shops_managment_screen.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/store_staff_management_screen/staff_managment_screen.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/store_sales_report_screen.dart/sales_report_screen.dart';
import '../../../widgets/menu_tile.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth > 600 ? screenWidth * 0.05 : 16.0;
    final verticalPadding = screenHeight > 800 ? 14.0 : 10.0;
    final tileSpacer = screenHeight > 800 ? 20.0 : 16.0;
    final titleFontSize = screenWidth > 600 ? 22.0 : 20.0;
    final iconSize = screenWidth > 600 ? 24.0 : 20.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: iconSize),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Menu",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
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
            SizedBox(height: tileSpacer),
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
            SizedBox(height: tileSpacer),
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
