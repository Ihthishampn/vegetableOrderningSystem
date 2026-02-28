import 'package:flutter/material.dart';

import '../../../../../store_vegetables_tab/presentation/widgets/add_success_message.dart';

class ShopsManagmentScreen extends StatefulWidget {
  const ShopsManagmentScreen({super.key});

  @override
  State<ShopsManagmentScreen> createState() => _ShopsManagmentScreenState();
}

class _ShopsManagmentScreenState extends State<ShopsManagmentScreen> {
  // Mock data based on your shared screenshot
  final List<Map<String, dynamic>> shops = [
    {
      "name": "Green Valley Grocery",
      "contact": "Rajesh Kumar",
      "mobile": "+91 98765 43210",
      "location": "Mumbai Market, Zone A",
      "date": "24/11/2025, 02:30am",
      "isActive": true,
    },
    {
      "name": "Demo Shop Name",
      "contact": "Rajesh Kumar",
      "mobile": "+91 98765 43210",
      "location": "Mumbai Market, Zone A",
      "date": "24/11/2025, 02:30am",
      "isActive": false,
    },
    {
      "name": "Demo Shop Name",
      "contact": "Rajesh Kumar",
      "mobile": "+91 98765 43210",
      "location": "Mumbai Market, Zone A",
      "date": "24/11/2025, 02:30am",
      "isActive": true,
    },
  ];

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
          "Shops",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Scrollable Shop List
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
            itemCount: shops.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildShopCard(index);
            },
          ),

          // 2. Fixed "Add New Shop" Button
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
                  // Navigate to Add Shop Page

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddShopPage(isEdit: false),
                    ),
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

  Widget _buildShopCard(int index) {
    final shop = shops[index];
    bool active = shop["isActive"];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1}. ${shop["name"]}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          _buildInfoRow("Contact Person", shop["contact"]),
          _buildInfoRow("Mobile Number", shop["mobile"]),
          _buildInfoRow("Location", shop["location"]),
          _buildInfoRow("Added Date", shop["date"]),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Edit Button (Adjusted height to match toggle)
              SizedBox(
                height: 32, // Controlled height
                child: OutlinedButton.icon(
                  onPressed: () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddShopPage(isEdit: true),
                        ),
                      );
                    }
                    ;
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Slim Status Toggle Container
              Container(
                height: 32, // Matches Edit button height
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 2,
                ), // Tighter padding
                decoration: BoxDecoration(
                  color: active
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: active
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      active ? "Active" : "Inactive",
                      style: TextStyle(
                        color: active ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12, // Slightly smaller font
                      ),
                    ),
                    const SizedBox(width: 2),
                    Transform.scale(
                      scale: 0.65, // Scale down the switch
                      child: Switch(
                        value: active,
                        // This is key: it removes the extra padding around the switch
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (val) {
                          setState(() => shops[index]["isActive"] = val);
                        },
                        activeColor: Colors.green,
                        activeTrackColor: Colors.green.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class AddShopPage extends StatelessWidget {
  final bool isEdit;
  const AddShopPage({super.key, this.isEdit = false});

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
        title: Text(
          isEdit ? "Edit Shop Details" : "Add New Shop",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Store Name *"),
              _buildTextField("Enter shop name"),
              const SizedBox(height: 12),

              _buildLabel("Contact Person Name *"),
              _buildTextField("Enter contact person name"),
              const SizedBox(height: 12),

              _buildLabel("Mobile Number"),
              _buildTextField(
                "Enter 10-digit mobile number",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),

              _buildLabel("Location / Address"),
              _buildTextField("Enter Location", maxLines: 4),
              const SizedBox(height: 120),

              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: const BorderSide(color: Colors.black12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. Show the success dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AddSuccessDialog(
                            title: isEdit ? "Shop Updated" : "Added New Shop",
                            message: isEdit
                                ? "The shop details have been successfully updated."
                                : "The shop has been successfully added.",
                          ),
                        );

                        // 2. Auto-close after animation
                        Future.delayed(const Duration(seconds: 3), () {
                          if (context.mounted) {
                            Navigator.pop(context); // Close Dialog
                            Navigator.pop(context); // Close Page
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D2926),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF2D2926)),
        ),
      ),
    );
  }
}
