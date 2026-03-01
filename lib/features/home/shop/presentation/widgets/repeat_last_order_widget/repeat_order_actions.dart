import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_now_screen.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';
import 'order_action_button.dart';

class RepeatOrderActions extends StatelessWidget {
  const RepeatOrderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProv, _) {
        final auth = Provider.of<AuthViewModel>(context, listen: false);
        final cart = Provider.of<CartProvider>(context, listen: false);

        final customerOrders = orderProv.allOrders
            .where((o) => o.customerId == auth.uid)
            .toList();
        customerOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (customerOrders.isEmpty) {
          return const SizedBox.shrink();
        }
        final last = customerOrders.first;

        return OrderActionButtons(
          onEdit: () {
            cart.clearCart();
            final prodProv = Provider.of<ProductProvider>(
              context,
              listen: false,
            );
            for (final item in last.items) {
              final current = prodProv.allProducts.firstWhere(
                (p) => p.id == item.productId,
                orElse: () => Product(
                  id: item.productId,
                  storeId: last.storeId,
                  name: item.productName,
                  unit: '',
                  imageUrl: null,
                  isAvailable: false,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
              if (!current.isAvailable) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${item.productName} is out of stock. Cannot edit or repeat this order.',
                    ),
                  ),
                );
                return;
              }
            }
            for (final item in last.items) {
              final current = prodProv.allProducts.firstWhere(
                (p) => p.id == item.productId,
              );
              cart.addToCart(
                Product(
                  id: current.id,
                  storeId: current.storeId,
                  name: current.name,
                  unit: current.unit,
                  imageUrl: current.imageUrl,
                  isAvailable: current.isAvailable,
                  createdAt: current.createdAt,
                  updatedAt: current.updatedAt,
                ),
                item.quantity,
                '',
              );
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderNowScreen(cartProvider: cart),
              ),
            );
          },
          onConfirm: () async {
            final prodProv = Provider.of<ProductProvider>(
              context,
              listen: false,
            );
            for (final item in last.items) {
              final current = prodProv.allProducts.firstWhere(
                (p) => p.id == item.productId,
                orElse: () => Product(
                  id: item.productId,
                  storeId: last.storeId,
                  name: item.productName,
                  unit: '',
                  imageUrl: null,
                  isAvailable: false,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
              if (!current.isAvailable) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${item.productName} is out of stock. Cannot repeat this order.',
                    ),
                  ),
                );
                return;
              }
            }
            final profileProv = Provider.of<StoreProfileProvider>(
              context,
              listen: false,
            );
            String customerName = auth.storeName?.trim() ?? '';
            if (customerName.isEmpty) {
              customerName =
                  profileProv.storeProfile?.storeName.trim() ?? '';
            }
            if (customerName.isEmpty) {
              customerName = auth.storeId ?? 'Shop';
            }
            String deliveryAddress =
                profileProv.storeProfile?.address ?? '';
            String customerPhone = auth.phoneNumber ?? '';
            final success = await orderProv.addOrder(
              customerId: auth.uid ?? '',
              customerName: customerName,
              customerPhone: customerPhone,
              deliveryAddress: deliveryAddress,
              items: last.items,
              totalPrice: last.totalPrice,
              scheduledDate: last.scheduledDate,
            );
            if (success) {
              showGeneralDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black54,
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) => const AddSuccessDialog(
                  title: "Order Repeated",
                  message: "Your previous order has been repeated.",
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
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            }
          },
        );
      },
    );
  }
}
