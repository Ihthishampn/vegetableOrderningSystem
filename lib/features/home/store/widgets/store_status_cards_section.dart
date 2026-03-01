import 'package:flutter/material.dart';
import 'status_card_row.dart';

class StoreStatusCardsSection extends StatelessWidget {
  final double toolbarHeight;

  const StoreStatusCardsSection({super.key, required this.toolbarHeight});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      toolbarHeight: toolbarHeight,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: StatusCardsRow(),
      ),
    );
  }
}
