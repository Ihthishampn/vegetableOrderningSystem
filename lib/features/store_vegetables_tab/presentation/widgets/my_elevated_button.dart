import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/core/constants/my_colors/my_colors.dart';

import '../screens/add_vegitable_form.dart';

class MyElevatedButton extends StatelessWidget {
  final Size size;
  const MyElevatedButton({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.01),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.only(
              right: size.width * 0.20,
              left: size.width * 0.20,
              top: size.height * 0.02,
              bottom: size.height * 0.02,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          backgroundColor: WidgetStatePropertyAll(MyColors.brownShadeColor),
        ),
        onPressed: () {
          showModalBottomSheet(
            enableDrag: true,
            context: context,
            isScrollControlled: true,
            builder: (_) => Material(child: AddVegetableForm()),
          );
        },
        child: Text(
          "+ Add New Vegetable",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
