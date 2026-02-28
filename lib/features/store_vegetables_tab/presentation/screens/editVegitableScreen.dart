import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/edit_page_custum_label.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/edit_unit_drop_down.dart';

import '../widgets/edit_form_action_button.dart';

class EditVegetablePage extends StatelessWidget {
  const EditVegetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          "Edit Vegetable",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: .w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vegetable Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1592924357228-91a4daadcfea',
                  height: 180,
                  width: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),

            const CustomLabel(text: "Sort Number *"),
            const CustomTextField(hint: "Enter sort number"),

            const SizedBox(height: 20),
            const CustomLabel(text: "Vegetable Name *"),
            const CustomTextField(hint: "e.g., Tomato"),

            const SizedBox(height: 20),
            const CustomLabel(text: "Select Default Unit *"),
            const UnitDropdown(),

            const SizedBox(height: 20),
            const CustomLabel(text: "Select Default unit"),
            const UnitSelectorChips(),

            const SizedBox(height: 100), // Space for bottom buttons
          ],
        ),
      ),
      bottomSheet: const FormActionButtons(),
    );
  }
}
