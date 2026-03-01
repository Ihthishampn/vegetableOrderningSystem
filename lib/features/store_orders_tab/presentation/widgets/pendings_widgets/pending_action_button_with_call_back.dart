
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../store_vegetables_tab/presentation/widgets/add_success_message.dart';
import '../../../domain/entities/order.dart';
import '../../provider/order_provider.dart';
import 'pending_outln_widget.dart';

class PendingActionFooterWithCallback extends StatelessWidget {
  final Order order;
  const PendingActionFooterWithCallback({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlineBtn(
                  text: "Reject Order",
                  color: Colors.red,
                  onPressed: () async {
                    final orderProvider = context.read<OrderProvider>();
                    final success = await orderProvider.rejectOrder(order.id);
                    if (!context.mounted) return;
                    if (success) {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierColor: Colors.black54,
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => const AddSuccessDialog(
                          title: "Order Rejected",
                          message: "The order has been rejected.",
                        ),
                        transitionBuilder: (_, anim, __, child) =>
                            ScaleTransition(
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
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: OutlineBtn(
                  text: "Approve",
                  color: Colors.black,
                  onPressed: () async {
                    final orderProvider = context.read<OrderProvider>();
                    final success = await orderProvider.approveOrder(order.id);
                    if (!context.mounted) return;
                    if (success) {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierColor: Colors.black54,
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => const AddSuccessDialog(
                          title: "Order Approved",
                          message: "The order has been approved.",
                        ),
                        transitionBuilder: (_, anim, __, child) =>
                            ScaleTransition(
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final orderProvider = context.read<OrderProvider>();
                final success = await orderProvider.completeOrder(order.id);
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Completed",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
