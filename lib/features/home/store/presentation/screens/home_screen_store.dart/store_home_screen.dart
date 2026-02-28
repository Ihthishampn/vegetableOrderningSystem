import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/home_screen_store.dart/store_menu_screen.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/screens/home_screen_store.dart/store_profile_screen.dart';

import '../../../widgets/circular_icon_widget.dart';
import '../../../widgets/home_order_items_store.dart';
import '../../../widgets/orders_header_store.dart';
import '../../../widgets/status_card_row.dart';
import '../../../widgets/top_home_appbar_content_store.dart';

class StoreHomeScreen extends StatelessWidget {
  const StoreHomeScreen({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: StatusCardsRow(),
            ),
          ),

          const SliverToBoxAdapter(child: OrdersHeader()),

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
