import 'package:flutter/material.dart';

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
          TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: const Color(0xFF2D2626),
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Available'),
              Tab(text: 'Unavailable'),
            ],
          ),
        ],
      ),
    );
  }
}