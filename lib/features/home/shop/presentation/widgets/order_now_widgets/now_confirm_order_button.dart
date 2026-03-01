import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_products_overview_screen.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';

class ConfirmOrderButton extends StatelessWidget {
  const ConfirmOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () async {
            // Gather necessary information and place order
            final cart = Provider.of<CartProvider>(context, listen: false);
            if (cart.cartItems.isEmpty) return;

            final auth = Provider.of<AuthProvider>(context, listen: false);
            final orderProv = Provider.of<OrderProvider>(
              context,
              listen: false,
            );
            final profileProv = Provider.of<StoreProfileProvider>(
              context,
              listen: false,
            );

            // ensure order provider initialized with supplier id
            if (orderProv.storeId == null && auth.storeId != null) {
              await orderProv.initialize(auth.storeId!);
            }

            // simple customer info; try to use store name from auth first (from shops collection)
            // then fall back to store profile if available.
            // always send a non-empty name so the store side can display it.
            String customerName = auth.storeName?.trim() ?? '';
            if (customerName.isEmpty) {
              customerName = profileProv.storeProfile?.storeName.trim() ?? '';
            }
            if (customerName.isEmpty) {
              // fallback to auth storeId or generic label
              customerName = auth.storeId ?? 'Shop';
            }
            String deliveryAddress = profileProv.storeProfile?.address ?? '';
            String customerPhone = auth.userRole == 'store'
                ? auth.phoneNumber ?? ''
                : '';

            final success = await orderProv.addOrder(
              customerId: auth.uid ?? '',
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
              totalPrice: 0.0,
            );

            if (success) {
              cart.clearCart();
              showGeneralDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black54,
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) => const AddSuccessDialog(
                  title: "Order Placed",
                  message: "Your order has been placed successfully.",
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
                // close the dialog
                Navigator.of(context, rootNavigator: true).pop();

                // after order placement, navigate to overview screen so shop
                // user can see details and cancel if desired.
                // pick the most recent order belonging to this customer
                final all = orderProv.allOrders
                    .where((o) => o.customerId == auth.uid)
                    .toList();
                if (all.isNotEmpty) {
                  all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  final latest = all.first;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ShopOrderOverview(order: latest),
                    ),
                  );
                } else {
                  // fallback: just pop the summary screen
                  if (context.mounted) Navigator.of(context).pop();
                }
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to place order: ${orderProv.error}'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B7FFF), // Primary Blue
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Confirm Order",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
