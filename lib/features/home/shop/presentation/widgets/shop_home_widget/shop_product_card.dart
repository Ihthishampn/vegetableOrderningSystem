
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String image;
  final List<String>? units;
  final bool isOutOfStock;

  const ProductCard({
    super.key,
    required this.name,
    required this.image,
    this.units,
    this.isOutOfStock = false,
  });

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
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.eco, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 1), // Space between the two sections
        
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
                  ? _buildStockButton("Out of Stock", Colors.grey)
                  : _buildStockButton("Add", const Color(0xFF5C79FF)),
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

  Widget _buildStockButton(String label, Color color) {
    return ElevatedButton(
      onPressed: isOutOfStock ? null : () {},
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
}