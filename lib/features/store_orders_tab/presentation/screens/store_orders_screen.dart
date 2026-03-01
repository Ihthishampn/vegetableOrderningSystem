import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order_provider.dart';
import '../widgets/order_screen_widgets/status_filter_bar.dart';
import '../widgets/order_screen_widgets/store_order_card.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'pending_over_view_screen.dart';
import 'approved_over_view_screen.dart';
import 'completed_over_view.dart';
import 'rejected_over_view.dart';

/// Screen displaying all orders for the store with filtering by status
class StoreOrdersScreen extends StatefulWidget {
  const StoreOrdersScreen({super.key});

  @override
  State<StoreOrdersScreen> createState() => _StoreOrdersScreenState();
}

class _StoreOrdersScreenState extends State<StoreOrdersScreen> {
  OrderStatus _selectedStatus = OrderStatus.pending;
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
      appBar: AppBar(
        elevation: 0,
        title: StatusFilterBar(
          selectedStatus: _selectedStatus,
          onStatusSelected: (s) => setState(() => _selectedStatus = s),
        ),
      ),
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

          // if there are no orders in the system at all, show generic message
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

          final filtered = provider.allOrders
              .where((o) => o.status == _selectedStatus)
              .toList();

          // if we have orders overall but none for the selected status, show
          // a status-specific empty message instead of an empty list
          if (filtered.isEmpty) {
            String label = '';
            switch (_selectedStatus) {
              case OrderStatus.pending:
                label = 'pending';
                break;
              case OrderStatus.approved:
                label = 'approved';
                break;
              case OrderStatus.completed:
                label = 'completed';
                break;
              case OrderStatus.rejected:
                label = 'rejected';
                break;
              case OrderStatus.cancelled:
                label = 'cancelled';
                break;
            }
            final message = label.isNotEmpty ? 'No $label yet' : 'No orders';
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(message, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }

          // overview counts removed (no overview chips)

          return Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final order = filtered[index];
                    final name = order.customerName.isNotEmpty
                        ? order.customerName
                        : 'Shop';
                    return GestureDetector(
                      onTap: () => _openOrderOverview(order),
                      child: StoreOrderCard(
                        storeNumber: index + 1,
                        storeName: name,
                        orderId: order.id,
                        orderStatus: order.status.toString().split('.').last,
                        totalPrice: order.totalPrice,
                        itemCount: order.items.length,
                        items: order.items,
                        createdAt: order.createdAt,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Overview chips removed per user request

  void _openOrderOverview(Order order) {
    // Navigate to appropriate overview screen based on order.status
    final status = order.status;
    if (status == OrderStatus.pending) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PendingOrderOverview(order: order)),
      );
    } else if (status == OrderStatus.approved) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ApprovedOrderOverview(order: order)),
      );
    } else if (status == OrderStatus.completed) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CompletedOrderOverview(order: order)),
      );
    } else if (status == OrderStatus.rejected) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RejectedOrderOverview(order: order)),
      );
    } else {
      // default
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PendingOrderOverview(order: order)),
      );
    }
  }
}
