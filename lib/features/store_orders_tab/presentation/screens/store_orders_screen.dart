import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order_provider.dart';
import '../widgets/order_screen_widgets/status_filter_bar.dart';
import '../widgets/order_screen_widgets/store_order_card.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'pending_over_view_screen.dart';
import 'approved_over_view_screen.dart';
import 'completed_over_view.dart';
import 'rejected_over_view.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthViewModel>();
      final orderProvider = context.read<OrderProvider>();
      final storeId = authProvider.uid;

      if (storeId != null && storeId.isNotEmpty) {
        orderProvider.initialize(storeId);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth > 600 ? screenWidth * 0.05 : 16.0;
    final iconSize = screenHeight > 800 ? 72.0 : 64.0;
    final spacingAfterIcon = screenHeight > 800 ? 20.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: StatusFilterBar(
          selectedStatus: _selectedStatus,
          onStatusSelected: (s) => setState(() => _selectedStatus = s),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<OrderProvider>(
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
                        SizedBox(height: spacingAfterIcon),
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
                        Icon(
                          Icons.inbox_outlined,
                          size: iconSize,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: spacingAfterIcon),
                        Text(
                          'No orders yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                var filtered = provider.allOrders
                    .where((o) => o.status == _selectedStatus)
                    .toList();

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
                  final message = label.isNotEmpty
                      ? 'No $label yet'
                      : 'No orders';
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: iconSize,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: spacingAfterIcon),
                        Text(
                          message,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(padding),
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
                        itemCount: order.items.length,
                        items: order.items,
                        createdAt: order.createdAt,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openOrderOverview(Order order) {
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
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PendingOrderOverview(order: order)),
      );
    }
  }
}
