import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/widgets/pendings_widgets/pending_outln_widget.dart';

/// Footer for shop-side order overview with a single "Cancel Order" action.
class ShopOrderActionFooter extends StatelessWidget {
  final Order order;
  const ShopOrderActionFooter({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlineBtn(
              text: "Cancel Order",
              color: Colors.red,
              onPressed: () async {
                final orderProvider = context.read<OrderProvider>();
                final success = await orderProvider.deleteOrder(order.id);
                if (!context.mounted) return;
                if (success) {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.black54,
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) => const AddSuccessDialog(
                      title: "Order Cancelled",
                      message: "Your order has been cancelled.",
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
