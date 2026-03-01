import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

class AdvanceOrderActions extends StatelessWidget {
  final DateTime scheduledDate;

  const AdvanceOrderActions({super.key, required this.scheduledDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                final cart = Provider.of<CartProvider>(context, listen: false);
                cart.clearCart();
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final cart = Provider.of<CartProvider>(context, listen: false);
                if (cart.cartItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Your cart is empty. Add items before placing a scheduled order.',
                      ),
                    ),
                  );
                  return;
                }

                final authLocal = Provider.of<AuthViewModel>(
                  context,
                  listen: false,
                );
                final orderProvLocal = Provider.of<OrderProvider>(
                  context,
                  listen: false,
                );
                final profileProvLocal = Provider.of<StoreProfileProvider>(
                  context,
                  listen: false,
                );

                if (orderProvLocal.storeId == null &&
                    authLocal.storeId != null) {
                  await orderProvLocal.initialize(authLocal.storeId!);
                }

                final storeId = orderProvLocal.storeId ?? authLocal.storeId;
                final customerId = authLocal.uid;
                if (storeId == null || storeId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Store ID missing. Cannot place order.'),
                    ),
                  );
                  return;
                }
                if (customerId == null || customerId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User not authenticated. Please log in.'),
                    ),
                  );
                  return;
                }

                String customerName = authLocal.storeName?.trim() ?? '';
                if (customerName.isEmpty) {
                  customerName =
                      profileProvLocal.storeProfile?.storeName.trim() ?? '';
                }
                if (customerName.isEmpty) customerName = storeId;

                String deliveryAddress =
                    profileProvLocal.storeProfile?.address ?? '';
                String customerPhone = authLocal.userRole == 'store'
                    ? authLocal.phoneNumber ?? ''
                    : '';

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Placing scheduled order...')),
                );

                bool success = false;
                try {
                  success = await orderProvLocal.addOrder(
                    customerId: customerId,
                    customerName: customerName,
                    customerPhone: customerPhone,
                    deliveryAddress: deliveryAddress,
                    items: cart.cartItems
                        .map(
                          (c) => OrderItem(
                            productId: c.product.id,
                            productName: c.product.name,
                            price: 0.0,
                            quantity: c.quantity,
                            unit: c.selectedUnit,
                            subtotal: 0.0,
                          ),
                        )
                        .toList(),
                    scheduledDate: scheduledDate,
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error placing order: $e')),
                    );
                  }
                  success = false;
                }

                if (!context.mounted) return;

                if (success) {
                  cart.clearCart();
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.black54,
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) => const AddSuccessDialog(
                      title: "Scheduled",
                      message: "Your scheduled order has been placed.",
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to place order: ${orderProvLocal.error}',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B7FFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Order", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
