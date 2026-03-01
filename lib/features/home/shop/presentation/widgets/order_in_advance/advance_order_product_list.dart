import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/widgets/shop_home_widget/shop_product_card.dart';

class AdvanceOrderProductList extends StatelessWidget {
  final String searchTerm;

  const AdvanceOrderProductList({
    super.key,
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (productProvider.error != null) {
            return Center(child: Text('Error: ${productProvider.error}'));
          }
          final products = productProvider.availableProducts.isEmpty
              ? productProvider.allProducts
              : productProvider.availableProducts;

          // apply search filter
          var filteredProducts = List.from(products);
          if (searchTerm.isNotEmpty) {
            filteredProducts = filteredProducts
                .where(
                  (p) => p.name.toLowerCase().contains(
                    searchTerm.toLowerCase(),
                  ),
                )
                .toList();
          }

          if (filteredProducts.isEmpty) {
            return const Center(child: Text('No products available'));
          }
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            children: filteredProducts
                .map(
                  (product) => ProductCard(
                    product: product,
                    name: product.name,
                    image: product.imageUrl ?? 'assets/placeholder.png',
                    units: [product.unit],
                    isOutOfStock: !product.isAvailable,
                    onAddToCart: !product.isAvailable
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
