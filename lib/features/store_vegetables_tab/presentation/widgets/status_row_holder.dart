import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

/// Header widget that contains the store status row AND the Available /
/// Unavailable [TabBar]. Requires a [TabController] from the parent so the
/// tab bar is in sync with the [TabBarView] rendered below it.
class StatusRowHolder extends StatelessWidget {
  final TabController tabController;

  const StatusRowHolder({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2626),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Status row (keep whatever you already had here) ──────────────
          // If your original StatusRowHolder had extra widgets above the
          // TabBar (e.g. a store-open toggle), place them here.

          // ── Tab bar ──────────────────────────────────────────────────────
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              final availableCount = provider.availableProducts.length;
              final unavailableCount = provider.unavailableProducts.length;
              return TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: const Color.fromARGB(255, 209, 209, 209),
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(text: 'Available ($availableCount)'),
                  Tab(text: 'Unavailable ($unavailableCount)'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
