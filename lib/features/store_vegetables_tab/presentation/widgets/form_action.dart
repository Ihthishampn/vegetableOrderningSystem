import 'package:flutter/material.dart';

import 'add_success_message.dart';

class FormActions extends StatelessWidget {
  const FormActions({super.key});

  void _showSuccess(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      // ignore: unnecessary_underscores
      pageBuilder: (_, __, ___) => const AddSuccessDialog(
        message: "The vegetable has been successfully addedd.",
        title: "Added New Vegetable",
      ),
      // ignore: unnecessary_underscores
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );

    // auto ayeett  message close aavum
    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      // close dialog
      Navigator.of(context, rootNavigator: true).pop();
      // close bottom sheet
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFD1D1D1)),
              ),
              minimumSize: const Size(0, 45),
            ),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showSuccess(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF2D2626),
              minimumSize: const Size(0, 45),
            ),
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

/// FormActions with custom submit callback for Firebase integration
class FormActionsWithCallback extends StatelessWidget {
  final VoidCallback onSubmit;
  final bool enabled;

  const FormActionsWithCallback({
    super.key,
    required this.onSubmit,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFD1D1D1)),
              ),
              minimumSize: const Size(0, 45),
            ),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: enabled ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: enabled ? const Color(0xFF2D2626) : Colors.grey,
              minimumSize: const Size(0, 45),
            ),
            child: Text(
              "Submit",
              style: TextStyle(color: enabled ? Colors.white : Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
