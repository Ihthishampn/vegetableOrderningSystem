import 'package:flutter/material.dart';

class AddSuccessDialog extends StatefulWidget {
  final String title;
  final String message;

  const AddSuccessDialog({
    super.key,
    this.title = "Added Successfully",
    this.message = "The details have been successfully saved.",
  });

  @override
  State<AddSuccessDialog> createState() => _AddSuccessDialogState();
}

class _AddSuccessDialogState extends State<AddSuccessDialog>
    with SingleTickerProviderStateMixin {
  bool _done = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // Simulate a short loading process before showing the checkmark
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _done = true);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          // Subtle gradient to match your style
          gradient: LinearGradient(
            colors: [const Color(0xFFD4DCFF).withOpacity(0.3), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Icon Circle
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _done ? const Color(0xFF4C78FF) : Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Center(
                child: _done
                    ? ScaleTransition(
                        scale: _scaleAnim,
                        child: const Icon(
                          Icons.check,
                          color: Color(0xFF4C78FF),
                          size: 50,
                        ),
                      )
                    : const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: Color(0xFF4C78FF),
                          strokeWidth: 3,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 25),

            // Title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C78FF),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}