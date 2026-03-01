import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';

import '../widgets/order_now_widgets/now_confirm_order_button.dart';
import '../widgets/order_now_widgets/now_summary.dart';
import '../widgets/order_now_widgets/now_summury_item_row.dart';
import '../widgets/order_now_widgets/now_total_item_banner.dart';

class OrderNowScreen extends StatelessWidget {
  final CartProvider? cartProvider;

  const OrderNowScreen({super.key, this.cartProvider});

  @override
  Widget build(BuildContext context) {
    if (cartProvider != null) {
      return ChangeNotifierProvider.value(
        value: cartProvider!,
        child: _buildScaffold(context),
      );
    }
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Summary",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C79FF),
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              OrderSummaryCard(
                orderId: "ORD${DateTime.now().millisecondsSinceEpoch}",
                storeName:
                    Provider.of<AuthViewModel>(
                      context,
                      listen: false,
                    ).storeId ??
                    "Your Store",
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
                              quantity: "${item.quantity} ${item.selectedUnit}",
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
      ),
    );
  }
}
