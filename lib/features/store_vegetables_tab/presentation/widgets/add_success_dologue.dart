
import 'package:flutter/material.dart';

class AddSuccessDialog extends StatefulWidget {
  const AddSuccessDialog({super.key});

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

    // Scale animation for circle
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
// loader done
    Future.delayed(const Duration(milliseconds: 800), () {
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD4DCFF), Color(0x00FFFFFF), Color(0xFFD4DCFF)],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green),
              ),
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Center(
                    child: _done
                        ? const Icon(
                            Icons.check,
                            color: Color(0xFF4C78FF),
                            size: 50,
                          )
                        : const CircularProgressIndicator(
                            color: Color(0xFF4C78FF),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Title text
            const Text(
              "Added New Vegetable",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C78FF),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "The vegetable has been successfully added.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 117, 117, 117),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
