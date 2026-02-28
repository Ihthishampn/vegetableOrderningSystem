import 'package:flutter/material.dart';

class FormActionButtons extends StatelessWidget {
  const FormActionButtons({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    color: Colors.white,
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D2926),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

/// FormActionButtons with custom callbacks for Firebase integration
class FormActionButtonsWithCallback extends StatelessWidget {
  final VoidCallback onSubmit;

  const FormActionButtonsWithCallback({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    color: Colors.white,
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D2926),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}
