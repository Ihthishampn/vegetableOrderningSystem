import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_now_screen.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';

import '../widgets/repeat_last_order_widget/order_action_button.dart';
import '../widgets/repeat_last_order_widget/repeat_card_summary.dart';
import '../widgets/repeat_last_order_widget/repeat_order_item_row.dart';
import '../widgets/repeat_last_order_widget/repeat_total_items_footer.dart';

class RepeatLastOrder extends StatelessWidget {
  const RepeatLastOrder({super.key});

  @override
  Widget build(BuildContext context) {
    // ensure order provider is initialized for supplier
    final auth = Provider.of<AuthProvider>(context, listen: false);
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
              final auth = Provider.of<AuthProvider>(context, listen: false);
              // find most recent order placed by this customer
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
                        final auth = Provider.of<AuthProvider>(
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
              final auth = Provider.of<AuthProvider>(context, listen: false);
              final cart = Provider.of<CartProvider>(context, listen: false);

              // determine last order again for callbacks
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
                  // load items into cart for user to modify, then go to summary
                  cart.clearCart();
                  for (final item in last.items) {
                    // create a minimal Product object for editing purposes
                    cart.addToCart(
                      Product(
                        id: item.productId,
                        storeId: last.storeId,
                        name: item.productName,
                        unit: '',
                        imageUrl: null,
                        isAvailable: true,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                      item.quantity,
                      '',
                    );
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OrderNowScreen()),
                  );
                },
                onConfirm: () async {
                  // repeat the order directly
                  final profileProv = Provider.of<StoreProfileProvider>(
                    context,
                    listen: false,
                  );
                  String customerName = '';
                  String deliveryAddress = '';
                  String customerPhone = auth.phoneNumber ?? '';
                  if (profileProv.storeProfile != null) {
                    customerName = profileProv.storeProfile!.storeName;
                    deliveryAddress = profileProv.storeProfile!.address;
                  }
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order repeated')),
                    );
                    Navigator.of(context).pop();
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
