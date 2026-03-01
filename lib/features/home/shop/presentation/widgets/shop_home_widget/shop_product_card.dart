import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';

class ProductCard extends StatefulWidget {
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
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 1;
  String? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.units?.isNotEmpty == true
        ? widget.units!.first
        : null;
  }

  void _addToCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    if (widget.product != null) {
      if (widget.isOutOfStock) {
        // out of stock items should not be added; inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${widget.name} is out of stock. Unable to add to cart.',
            ),
          ),
        );
        return;
      }
      // Ensure a unit is selected; fallback to first available unit or empty
      final unitToUse = _selectedUnit != null && _selectedUnit!.isNotEmpty
          ? _selectedUnit!
          : (widget.units != null && widget.units!.isNotEmpty
                ? widget.units!.first
                : '');
      try {
        cart.addToCart(widget.product!, _quantity, unitToUse);
        widget.onAddToCart?.call();
      } catch (e) {
        // Report unexpected errors to console only (no Scaffold message)
        // UI will reflect the change via Provider listeners if add succeeds.
        // Use debugPrint to avoid showing messages to users.
        debugPrint('Failed to add ${widget.name} to cart: $e');
      }
    } else {
      widget.onAddToCart?.call();
    }
  }

  void _increment() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    setState(() => _quantity += 1);
    if (widget.product != null) {
      cart.updateQuantity(widget.product!.id, _quantity);
    }
  }

  void _decrement() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    if (_quantity > 1) {
      setState(() => _quantity -= 1);
      if (widget.product != null) {
        cart.updateQuantity(widget.product!.id, _quantity);
      }
    } else {
      // remove from cart when quantity reaches 0
      if (widget.product != null) {
        cart.removeFromCart(widget.product!.id);
      }
      setState(() => _quantity = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        // Check if this product is already in the cart to determine button state
        final isInCart =
            widget.product != null &&
            cart.cartItems.any((item) => item.product.id == widget.product!.id);

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
                      widget.name,
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
                    child: !widget.isOutOfStock && widget.units != null
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: widget.units!
                                  .map((u) => _buildUnitChip(u))
                                  .toList(),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  widget.isOutOfStock
                      ? _buildStockButton(
                          "Out of Stock",
                          Colors.grey,
                          null,
                          isInCart,
                        )
                      : _buildStockButton(
                          "Add",
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

  /// Build image widget (handles both asset and network URLs)
  Widget _buildImage() {
    final image = widget.image;
    if (image.startsWith('http')) {
      // Network image
      return Image.network(
        image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.eco, color: Colors.green),
      );
    } else if (image.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.eco, color: Colors.green),
      );
    } else {
      // Fallback
      return const Icon(Icons.eco, color: Colors.green);
    }
  }

  Widget _buildStockButton(
    String label,
    Color color,
    VoidCallback? onPressed,
    bool isInCart,
  ) {
    if (!isInCart) {
      return ElevatedButton(
        onPressed: widget.isOutOfStock
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.name} is out of stock. Cannot order now.',
                    ),
                  ),
                );
              }
            : _addToCart,
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

    // Quantity selector UI with +/- icons and a small cancel (remove) icon
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
                onTap: _decrement,
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
                  _quantity.toString().padLeft(2, '0'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _increment,
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
        // small cancel/remove icon positioned at top-right of the selector
        Positioned(
          right: -12,
          top: -12,
          child: GestureDetector(
            onTap: () {
              // remove from cart
              final cart = Provider.of<CartProvider>(context, listen: false);
              if (widget.product != null) {
                cart.removeFromCart(widget.product!.id);
              }
              setState(() => _quantity = 1);
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
