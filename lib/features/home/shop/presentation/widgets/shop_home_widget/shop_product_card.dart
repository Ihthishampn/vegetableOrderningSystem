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
  bool _added = false;
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
      cart.addToCart(widget.product!, _quantity, _selectedUnit ?? '');
    }
    setState(() => _added = true);
    widget.onAddToCart?.call();
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
      // remove from cart
      if (widget.product != null) {
        cart.removeFromCart(widget.product!.id);
      }
      setState(() {
        _quantity = 1;
        _added = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

          const SizedBox(height: 1), // Space between the two sections

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
                  ? _buildStockButton("Out of Stock", Colors.grey, null)
                  : _buildStockButton(
                      "Add",
                      const Color(0xFF5C79FF),
                      widget.onAddToCart,
                    ),
            ],
          ),
        ],
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

  Widget _buildStockButton(String label, Color color, VoidCallback? onPressed) {
    if (!_added) {
      return ElevatedButton(
        onPressed: onPressed ?? _addToCart,
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
          right: -8,
          top: -8,
          child: GestureDetector(
            onTap: () {
              // remove from cart and reset UI
              final cart = Provider.of<CartProvider>(context, listen: false);
              if (widget.product != null) {
                cart.removeFromCart(widget.product!.id);
              }
              setState(() {
                _added = false;
                _quantity = 1;
              });
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
