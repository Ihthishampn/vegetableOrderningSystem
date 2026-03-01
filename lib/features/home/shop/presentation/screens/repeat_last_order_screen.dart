import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_now_screen.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';

import '../widgets/repeat_last_order_widget/order_action_button.dart';
import '../widgets/repeat_last_order_widget/repeat_card_summary.dart';
import '../widgets/repeat_last_order_widget/repeat_order_item_row.dart';
import '../widgets/repeat_last_order_widget/repeat_total_items_footer.dart';

class RepeatLastOrder extends StatelessWidget {
  const RepeatLastOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
    if (orderProv.storeId == null && auth.storeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProv.initialize(auth.storeId!);
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Previous Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Consumer<OrderProvider>(
            builder: (context, orderProv, _) {
              final auth = Provider.of<AuthViewModel>(context, listen: false);
              final customerOrders = orderProv.allOrders
                  .where((o) => o.customerId == auth.uid)
                  .toList();
              customerOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              if (customerOrders.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No previous orders'),
                );
              }
              final last = customerOrders.first;
              return OrderSummaryHeader(
                orderId: last.id,
                storeName: last.storeId,
                itemCount: last.items.length,
              );
            },
          ),

          const SizedBox(height: 24),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ordered items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Consumer<OrderProvider>(
                      builder: (context, orderProv, _) {
                        final auth = Provider.of<AuthViewModel>(
                          context,
                          listen: false,
                        );
                        final customerOrders = orderProv.allOrders
                            .where((o) => o.customerId == auth.uid)
                            .toList();
                        if (customerOrders.isEmpty) {
                          return const Center(child: Text('No items'));
                        }
                        customerOrders.sort(
                          (a, b) => b.createdAt.compareTo(a.createdAt),
                        );
                        final last = customerOrders.first;
                        return ListView.builder(
                          itemCount: last.items.length,
                          itemBuilder: (context, idx) {
                            final item = last.items[idx];
                            return OrderItemRow(
                              index: idx + 1,
                              name: item.productName,
                              quantity: '${item.quantity}',
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const TotalItemsFooter(total: "05"),
          Consumer<OrderProvider>(
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
          ),
        ],
      ),
    );
  }
}
