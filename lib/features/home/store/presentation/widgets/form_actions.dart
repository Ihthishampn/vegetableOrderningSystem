import 'package:flutter/material.dart';

class FormActions extends StatelessWidget {
  const FormActions({
    super.key,
    required this.isLoading,
    required this.canSubmit,
    required this.onCancel,
    required this.onSubmit,
  });

  final bool isLoading;
  final bool canSubmit;
  final VoidCallback onCancel;

  final Future<bool> Function(BuildContext context) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              side: const BorderSide(color: Colors.black12),
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: (isLoading || !canSubmit)
                ? null
                : () async {
                    final localContext = context;
                    final completed = await onSubmit(localContext);
                    if (completed && localContext.mounted) {
                      Navigator.pop(localContext);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D2926),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
