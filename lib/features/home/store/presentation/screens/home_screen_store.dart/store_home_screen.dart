import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../widgets/orders_header_store.dart';
import '../../../widgets/store_home_appbar.dart';
import '../../../widgets/store_status_cards_section.dart';
import '../../../widgets/store_orders_list.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final appBarHeight = screenHeight * 0.12;
    final statusCardsHeight = screenHeight * 0.11;
    final horizontalPadding = screenWidth > 600 ? screenWidth * 0.05 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StoreHomeAppBar(expandedHeight: appBarHeight),
          StoreStatusCardsSection(toolbarHeight: statusCardsHeight),
          const SliverToBoxAdapter(child: OrdersHeader()),
          StoreOrdersList(formatDate: _formatDate),
        ],
      ),
    );
  }
}
