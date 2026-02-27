import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/core/constants/my_colors/my_colors.dart';

class StatusRowHolder extends StatelessWidget {
  const StatusRowHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), // padding inside container
      decoration: BoxDecoration(
        color: MyColors.brownShadeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white70, width: 1),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(text: "Available 11"),
          Tab(text: "Unavailable 4"),
        ],
      ),
    );
  }
}