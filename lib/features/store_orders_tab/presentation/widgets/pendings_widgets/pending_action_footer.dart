import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'pending_outln_widget.dart';

class PendingActionFooter extends StatelessWidget {
  const PendingActionFooter({super.key});

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
                child: OutlineBtn(text: "Reject Order", color: Colors.red),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: OutlineBtn(text: "Approve", color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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

/// Action footer with Firebase callbacks
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
                    await orderProvider.rejectOrder(order.id);
                    if (context.mounted) Navigator.pop(context);
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
                    await orderProvider.approveOrder(order.id);
                    if (context.mounted) Navigator.pop(context);
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
                await orderProvider.completeOrder(order.id);
                if (context.mounted) Navigator.pop(context);
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
