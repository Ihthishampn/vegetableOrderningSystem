import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/home_screen_store.dart/store_menu_screen.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/home_screen_store.dart/store_profile_screen.dart';

import '../../../widgets/circular_icon_widget.dart';
import '../../../widgets/home_order_items_store.dart';
import '../../../widgets/orders_header_store.dart';
import '../../../widgets/status_card_row.dart';
import '../../../widgets/top_home_appbar_content_store.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthViewModel>();
      final storeId = auth.uid;
      if (storeId != null && storeId.isNotEmpty) {
        final orderProvider = context.read<OrderProvider>();
        orderProvider.initialize(storeId);
      }
    });
  }

  String _formatDate(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year}, $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.12,
            backgroundColor: Colors.transparent,
            actions: [
              CircularIcon(
                icon: Icons.menu,
                ontap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => MenuPage()));
                },
              ),
              CircularIcon(
                icon: Icons.person_outline,
                ontap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => StoreProfilePage()),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: TopAppBarContent(size: size),
            ),
          ),

          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            toolbarHeight: size.height * 0.11,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: StatusCardsRow(),
            ),
          ),

          const SliverToBoxAdapter(child: OrdersHeader()),

          Consumer<OrderProvider>(
            builder: (context, orders, _) {
              if (orders.isLoading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (orders.error != null) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${orders.error}'),
                    ),
                  ),
                );
              }

              final list = orders.allOrders;
              if (list.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('No orders yet'),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final order = list[index];
                  final storeName = order.customerName.isNotEmpty
                      ? order.customerName
                      : 'Shop';
                  final date = _formatDate(order.createdAt);
                  return OrderItemCard(
                    storeName: storeName,
                    date: date,
                    items: order.items,
                  );
                }, childCount: list.length),
              );
            },
          ),
        ],
      ),
    );
  }
}
