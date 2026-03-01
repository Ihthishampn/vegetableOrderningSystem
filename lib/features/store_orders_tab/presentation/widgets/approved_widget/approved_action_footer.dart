import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';

// static footer that does nothing (kept for reference)
class ApprovedActionFooter extends StatelessWidget {
  const ApprovedActionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {}, // placeholder
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D2926),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Completed",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

/// Footer that performs provider callback to mark order complete
class ApprovedActionFooterWithCallback extends StatelessWidget {
  final Order order;
  const ApprovedActionFooterWithCallback({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            final orderProv = context.read<OrderProvider>();
            final success = await orderProv.completeOrder(order.id);
            if (!context.mounted) return;
            if (success) {
              showGeneralDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black54,
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) => const AddSuccessDialog(
                  title: "Order Completed",
                  message: "The order has been marked completed.",
                ),
                transitionBuilder: (_, anim, __, child) => ScaleTransition(
                  scale: CurvedAnimation(
                    parent: anim,
                    curve: Curves.easeOutBack,
                  ),
                  child: child,
                ),
              );

              Future.delayed(const Duration(seconds: 2), () {
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).pop();
              });
            } else {
              if (context.mounted) Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D2926),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Completed",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
