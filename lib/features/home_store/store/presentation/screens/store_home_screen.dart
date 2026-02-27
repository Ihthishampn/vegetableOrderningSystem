import 'package:flutter/material.dart';

import '../../widgets/circular_icon_widget.dart';
import '../../widgets/home_order_items_store.dart';
import '../../widgets/orders_header_store.dart';
import '../../widgets/status_card_row.dart';
import '../../widgets/top_home_appbar_content_store.dart';

class StoreHomeScreen extends StatelessWidget {
  const StoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Curved AppBar with title, subtitle, and icons
          SliverAppBar(
            expandedHeight: size.height * 0.11,
            backgroundColor: Colors.transparent,
            actions: const [
              CircularIcon(icon: Icons.menu),
              CircularIcon(icon: Icons.person_outline),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: TopAppBarContent(size: size),
            ),
          ),

          // Pinned Cards
          const SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            toolbarHeight: 90,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: StatusCardsRow(),
            ),
          ),

          // Orders header
          const SliverToBoxAdapter(child: OrdersHeader()),

          // Orders list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const OrderItemCard(
                storeName: "Green Valley Store",
                date: "24/11/2025, 04:30am",
              ),
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}


