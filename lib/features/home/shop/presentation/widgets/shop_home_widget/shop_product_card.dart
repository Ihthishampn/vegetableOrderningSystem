import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/product_card_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product? product;
  final String name;
  final String image;
  final List<String>? units;
  final bool isOutOfStock;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    this.product,
    required this.name,
    required this.image,
    this.units,
    this.isOutOfStock = false,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductCardProvider>(
      create: (_) => ProductCardProvider(
        cart: Provider.of<CartProvider>(context, listen: false),
        product: product,
        units: units,
        isOutOfStock: isOutOfStock,
      ),
      child: Consumer2<CartProvider, ProductCardProvider>(
        builder: (context, cart, model, _) {
          final isInCart =
              product != null &&
              cart.cartItems.any((item) => item.product.id == product!.id);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: !isOutOfStock && units != null
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: units!
                                    .map((u) => _buildUnitChip(u))
                                    .toList(),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    isOutOfStock
                        ? _buildStockButton(
                            context,
                            'Out of Stock',
                            Colors.grey,
                            null,
                            isInCart,
                          )
                        : _buildStockButton(
                            context,
                            'Add',
                            const Color(0xFF5C79FF),
                            null,
                            isInCart,
                          ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnitChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  Widget _buildImage() {
    final url = image;
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.eco, color: Colors.green),
      );
    } else if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.eco, color: Colors.green),
      );
    } else {
      return const Icon(Icons.eco, color: Colors.green);
    }
  }

  Widget _buildStockButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback? onPressed,
    bool isInCart,
  ) {
    final model = Provider.of<ProductCardProvider>(context, listen: false);
    if (!isInCart) {
      return ElevatedButton(
        onPressed: isOutOfStock
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name is out of stock. Cannot order now.'),
                  ),
                );
              }
            : () => model.addToCart(context, onAdd: onAddToCart),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          elevation: 2,
          shadowColor: Colors.black26,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: model.decrement,
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  child: const Icon(Icons.remove, size: 18),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FB),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  model.quantity.toString().padLeft(2, '0'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: model.increment,
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  child: const Icon(Icons.add, size: 18),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: -12,
          top: -12,
          child: GestureDetector(
            onTap: () {
              final cart = Provider.of<CartProvider>(context, listen: false);
              if (product != null) {
                cart.removeFromCart(product!.id);
              }
              model.decrement();
            },
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
