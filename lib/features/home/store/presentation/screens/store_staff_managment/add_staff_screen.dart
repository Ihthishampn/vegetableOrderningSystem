import 'package:flutter/material.dart';

import '../../../../../store_vegetables_tab/presentation/widgets/add_success_message.dart';

class AddStaffPage extends StatelessWidget {
  const AddStaffPage({super.key});

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
          "Add New Staff",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Staff Name *"),
            _buildTextField("Enter staff name"),
            const SizedBox(height: 20),

            _buildLabel("Mobile Number *"),
            _buildTextField(
              "Enter 10-digit mobile number",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            _buildLabel("Role *"),
            _buildTextField("Select role"),

            const Spacer(),

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
                      // 1. Show the success animation dialog
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // User must wait for animation
                        builder: (context) => const AddSuccessDialog(
                          title: "Added new Staff",
                          message: "The staff has been succesfully added",
                        ),
                      );

                      // 2. Auto-close the dialog and the page after a delay
                      Future.delayed(const Duration(seconds: 3), () {
                        if (context.mounted) {
                          Navigator.pop(context); // Closes Dialog
                          Navigator.pop(context); // Closes Add Staff Page
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
