import 'package:flutter/material.dart';

class StoreDropdownMenu extends StatelessWidget {
  final String selectedStore;
  final List<String> stores;
  final Function(String) onStoreSelected;
  final VoidCallback onClose;

  const StoreDropdownMenu({
    super.key,
    required this.selectedStore,
    required this.stores,
    required this.onStoreSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> storesList = stores;
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Store",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: storesList.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final store = storesList[index];
                  final isSelected = store == selectedStore;
                  return InkWell(
                    onTap: () => onStoreSelected(store),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: isSelected
                          ? const Color(0xFFE3F2FD)
                          : Colors.transparent,
                      child: Text(
                        store,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
