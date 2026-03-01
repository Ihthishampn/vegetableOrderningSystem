import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'now_summary.dart';
import 'now_summury_item_row.dart';
import 'now_total_item_banner.dart';
import 'now_confirm_order_button.dart';

class OrderContentView extends StatelessWidget {
  final CartProvider cartProvider;

  const OrderContentView({
    super.key,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final authView = Provider.of<AuthViewModel>(
          context,
          listen: false,
        );
        final displayName = authView.storeName?.trim().isNotEmpty == true
            ? authView.storeName!
            : authView.storeId ?? "Your Store";

        return Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Column(
              children: [
                OrderSummaryCard(
                  orderId: "ORD\\${DateTime.now().millisecondsSinceEpoch}",
                  storeName: displayName,
                  itemCount: cart.itemCount,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ordered items",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cart.cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cart.cartItems[index];
                              return SummaryItemRow(
                                label: "${index + 1} ${item.product.name}",
                                quantity:
                                    "${item.quantity} ${item.selectedUnit}",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TotalItemsBanner(
                  total: cart.itemCount.toString().padLeft(2, '0'),
                ),
                const ConfirmOrderButton(),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }
}
