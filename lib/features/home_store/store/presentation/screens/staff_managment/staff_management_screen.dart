import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home_store/store/presentation/screens/staff_managment/add_staff_screen.dart';

import 'edit_staff_screen.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data based on your screenshot
    final List<Map<String, String>> staffList = [
      {"name": "John Mathew", "phone": "+91 98765 43210", "role": "Demo role"},
      {"name": "Sreerag", "phone": "+91 98765 43210", "role": "Demo role"},
      {"name": "Sadiq Ali", "phone": "+91 98765 43210", "role": "Demo role"},
      {"name": "Saleeq", "phone": "+91 98765 43210", "role": "Demo role"},
    ];

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
          "Staffs",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Scrollable List of Staff
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              100,
            ), // Extra bottom padding for button
            itemCount: staffList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final staff = staffList[index];
              return _buildStaffCard(
                name: staff["name"]!,
                phone: staff["phone"]!,
                role: staff["role"]!,
                c: context,
              );
            },
          ),

          // 2. Fixed "Add New Staff" Button at Bottom
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
                  // Action to add new staff
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddStaffPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2926), // Dark theme color
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "+ Add New Staff",
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

  Widget _buildStaffCard({
    required String name,
    required String phone,
    required String role,
    required BuildContext c,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Staff Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  role,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // Action Icons
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                c,
                MaterialPageRoute(builder: (context) => const EditStaffPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
