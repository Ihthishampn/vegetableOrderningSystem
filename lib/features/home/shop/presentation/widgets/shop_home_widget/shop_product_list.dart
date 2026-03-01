import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import '../shop_home_widget/shop_product_card.dart';

class ShopProductList extends StatelessWidget {
  final String searchTerm;

  const ShopProductList({super.key, required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final auth = Provider.of<AuthViewModel>(context, listen: false);
        final orderProvider = Provider.of<OrderProvider>(
          context,
          listen: false,
        );
        if (productProvider.storeId == null && auth.storeId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            productProvider.initialize(auth.storeId!);
            orderProvider.initialize(auth.storeId!);
          });
        }

        if (productProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (productProvider.error != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('Error: ${productProvider.error}')),
          );
        }

        var products = List<Product>.from(productProvider.allProducts);
        if (searchTerm.isNotEmpty) {
          products = products
              .where(
                (p) => p.name.toLowerCase().contains(searchTerm.toLowerCase()),
              )
              .toList();
        }
        products.sort((a, b) {
          final avA = a.isAvailable ? 0 : 1;
          final avB = b.isAvailable ? 0 : 1;
          return avA.compareTo(avB);
        });

        if (products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('No products available')),
          );
        }

        return Column(
          children: products
              .map(
                (product) => ProductCard(
                  product: product,
                  name: product.name,
                  image: product.imageUrl ?? "assets/placeholder.png",
                  units: [product.unit],
                  isOutOfStock: !product.isAvailable,
                  onAddToCart: !product.isAvailable
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
