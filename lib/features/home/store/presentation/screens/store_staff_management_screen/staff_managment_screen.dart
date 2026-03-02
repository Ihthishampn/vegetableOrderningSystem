import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_staff/presentation/provider/staff_provider.dart';
import 'package:vegetable_ordering_system/features/store_staff/domain/entities/staff.dart';
import '../../widgets/staff_card.dart';
import '../../pages/add_staff_page.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthViewModel>(context, listen: false);
      final staffProv = Provider.of<StaffProvider>(context, listen: false);
      if (auth.uid != null) {
        staffProv.initialize(auth.uid!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth > 600 ? screenWidth * 0.05 : 16.0;
    final separatorHeight = screenHeight > 800 ? 20.0 : 16.0;
    final buttonHeight = screenHeight > 800 ? 65.0 : 55.0;
    final buttonPadding = screenHeight > 800 ? 24.0 : 20.0;
    final listPaddingBottom = screenHeight > 800 ? 120.0 : 100.0;
    final titleFontSize = screenWidth > 600 ? 20.0 : 18.0;
    final iconSize = screenWidth > 600 ? 24.0 : 20.0;
    final buttonFontSize = screenWidth > 600 ? 18.0 : 16.0;

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
          "Staff",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Consumer<StaffProvider>(
            builder: (context, staffProv, _) {
              if (staffProv.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (staffProv.error != null) {
                return Center(child: Text('Error: ${staffProv.error}'));
              }
              final staffList = staffProv.staffList;
              if (staffList.isEmpty) {
                return const Center(
                  child: Text(
                    "No staff yet. Add one now.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(padding, 10, padding, listPaddingBottom),
                itemCount: staffList.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: separatorHeight),
                itemBuilder: (context, index) {
                  final Staff staff = staffList[index];
                  return StaffCard(staff: staff);
                },
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(buttonPadding),
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
                    MaterialPageRoute(
                      builder: (context) => const AddStaffPage(),
                    ),
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
                  "+ Add New Staff",
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

