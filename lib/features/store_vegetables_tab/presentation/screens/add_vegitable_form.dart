import 'package:flutter/material.dart';

import '../widgets/defauly_unit_selector.dart';
import '../widgets/form_action.dart';
import '../widgets/form_header.dart';
import '../widgets/image_pick_area.dart';
import '../widgets/label_and_field.dart';

class AddVegetableForm extends StatelessWidget {
  const AddVegetableForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            FormHeader(),
            SizedBox(height: 20),
            ImagePickerBox(),
            SizedBox(height: 20),
            LabelAndField(label: "Sort Number *", hint: "Enter sort number"),
            SizedBox(height: 15),
            LabelAndField(label: "Vegetable Name *", hint: "e.g., Tomato"),
            SizedBox(height: 15),
            DefaultUnitSelector(),
            SizedBox(height: 30),
            FormActions(),
          ],
        ),
      ),
    );
  }
}


// Image upload area


// Label + TextField


// Unit selector dropdown and chips


// Single unit chip

// Bottom buttons row
