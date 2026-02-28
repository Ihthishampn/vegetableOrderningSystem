import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

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

            // simple customer info; try to use store profile if available
            String customerName = '';
            String deliveryAddress = '';
            String customerPhone = auth.userRole == 'store'
                ? auth.phoneNumber ?? ''
                : '';
            if (profileProv.storeProfile != null) {
              // storeProfile contains storeName and ownerName
              customerName = profileProv.storeProfile!.storeName;
              deliveryAddress = profileProv.storeProfile!.address;
            }

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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully')),
              );
              Navigator.of(context).pop();
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
