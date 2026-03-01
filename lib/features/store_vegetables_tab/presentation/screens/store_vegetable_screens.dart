import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/screens/editVegitableScreen.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/my_elevated_button.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';

import '../widgets/status_row_holder.dart';
import '../widgets/vege_item_card.dart';

class StoreVegetableScreens extends StatefulWidget {
  const StoreVegetableScreens({super.key});

  @override
  State<StoreVegetableScreens> createState() => _StoreVegetableScreensState();
}

class _StoreVegetableScreensState extends State<StoreVegetableScreens>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthViewModel>();
      final productProvider = context.read<ProductProvider>();
      final storeId = authProvider.uid;

      if (storeId != null && storeId.isNotEmpty) {
        productProvider.initialize(storeId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),

            StatusRowHolder(tabController: _tabController),
            Expanded(
              child: Consumer<ProductProvider>(
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
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: provider.fetchProducts,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return TabBarView(
                    // Attach the controller so tab switching is in sync with
                    // the TabBar above.
                    controller: _tabController,
                    children: [
                      _buildVegetableList(context, provider.availableProducts),
                      _buildVegetableList(
                        context,
                        provider.unavailableProducts,
                      ),
                    ],
                  );
                },
              ),
            ),
            MyElevatedButton(size: Size(width, height)),
          ],
        ),
      ),
    );
  }

  Widget _buildVegetableList(BuildContext context, List products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No products yet', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return VegetableItemCard(
          product: product,
          onEdit: () => _showEditSheet(context, product),

          onDelete: () =>
              context.read<ProductProvider>().deleteProduct(product.id),
          onToggleAvailability: () => _toggleAvailability(context, product),
        );
      },
    );
  }

  void _showEditSheet(BuildContext context, product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditVegetablePage(product: product),
    );
  }

  void _toggleAvailability(BuildContext context, product) {
    context.read<ProductProvider>().toggleAvailability(product);
  }
}
