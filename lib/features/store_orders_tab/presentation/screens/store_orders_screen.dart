import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order_provider.dart';
import '../widgets/order_screen_widgets/status_filter_bar.dart';
import '../widgets/order_screen_widgets/store_order_card.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';

/// Screen displaying all orders for the store with filtering by status
class StoreOrdersScreen extends StatefulWidget {
  const StoreOrdersScreen({super.key});

  @override
  State<StoreOrdersScreen> createState() => _StoreOrdersScreenState();
}

class _StoreOrdersScreenState extends State<StoreOrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize OrderProvider with current store ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final orderProvider = context.read<OrderProvider>();
      final storeId = authProvider.uid;

      if (storeId != null && storeId.isNotEmpty) {
        orderProvider.initialize(storeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const StatusFilterBar()),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.fetchOrders,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.allOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.allOrders.length,
            itemBuilder: (context, index) {
              final order = provider.allOrders[index];
              return StoreOrderCard(
                storeNumber: 1,
                storeName: order.customerName,
                orderId: order.id,
                orderStatus: order.status.toString().split('.').last,
                totalPrice: order.totalPrice,
                itemCount: order.items.length,
                createdAt: order.createdAt,
              );
            },
          );
        },
      ),
    );
  }
}
