import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/my_elevated_button.dart';

import '../widgets/status_row_holder.dart';
import '../widgets/vege_item_card.dart';

class StoreVegetableScreens extends StatelessWidget {
  const StoreVegetableScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2, // Available and Unavailable
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 6),
              // Updated top status row holder to act as a TabBar
              const StatusRowHolder(),

              // Slidable area for vegetables
              Expanded(
                child: TabBarView(
                  children: [
                    _buildVegetableList(context, "Available"),
                    _buildVegetableList(context, "Unavailable"),
                  ],
                ),
              ),

              // button for add veg
              MyElevatedButton(size: Size(width, height)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVegetableList(BuildContext context, String status) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) => const VegetableItemCard(),
    );
  }
}
