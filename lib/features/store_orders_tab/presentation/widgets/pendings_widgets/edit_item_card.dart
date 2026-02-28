import 'package:flutter/material.dart';

class EditItemCard extends StatefulWidget {
  final String name;
  final String imageUrl;

  const EditItemCard({super.key, required this.name, required this.imageUrl});

  @override
  State<EditItemCard> createState() => _EditItemCardState();
}

class _EditItemCardState extends State<EditItemCard> {
  String selectedUnit = "kg";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents vertical overflow
        children: [
          Row(
            children: [
              Image.network(widget.imageUrl, height: 35, width: 35),
              const SizedBox(width: 10),
              Expanded(
                // Allows text to wrap or shrink if name is long
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // 1. Unit Selectors - Wrap in Expanded to prevent horizontal overflow
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["kg", "Box", "Bag"].map((unit) {
                      bool isSel = selectedUnit == unit;
                      return GestureDetector(
                        onTap: () => setState(() => selectedUnit = unit),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSel
                                ? const Color(0xFFE8EFFF)
                                : Colors.grey.shade100,
                            border: Border.all(
                              color: isSel ? Colors.blue : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            unit,
                            style: TextStyle(
                              color: isSel ? Colors.blue : Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 2. Quantity Incrementor
              Container(
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // Essential to prevent overflow
                  children: [
                    _qtyBtn(
                      Icons.remove,
                      () => setState(() => quantity > 1 ? quantity-- : null),
                    ),
                    Text(
                      quantity.toString().padLeft(2, '0'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _qtyBtn(Icons.add, () => setState(() => quantity++)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => IconButton(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    padding: EdgeInsets.zero,
    splashRadius: 20,
  );
}