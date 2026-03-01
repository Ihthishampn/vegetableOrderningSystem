import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';

import '../../../../../auth/presentation/viewmodels/auth_viewmodel.dart';

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
            final cart = Provider.of<CartProvider>(context, listen: false);
            if (cart.cartItems.isEmpty) return;

            final auth = Provider.of<AuthViewModel>(context, listen: false);
            final orderProv = Provider.of<OrderProvider>(
              context,
              listen: false,
            );
            final profileProv = Provider.of<StoreProfileProvider>(
              context,
              listen: false,
            );

            if (orderProv.storeId == null && auth.storeId != null) {
              await orderProv.initialize(auth.storeId!);
            }

           
            String customerName = auth.storeName?.trim() ?? '';
            if (customerName.isEmpty) {
              customerName = profileProv.storeProfile?.storeName.trim() ?? '';
            }
            if (customerName.isEmpty) {
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
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
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
            backgroundColor: const Color(0xFF5B7FFF), 
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
