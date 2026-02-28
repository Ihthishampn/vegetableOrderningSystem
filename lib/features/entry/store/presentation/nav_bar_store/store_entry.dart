import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/entry_provider.dart';

class StoreEntry extends StatelessWidget {
  const StoreEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EntryProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
    
      },
      child: Scaffold(
        body: IndexedStack(
          index: provider.selectedIndex,
          children: provider.widgetStack,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: provider.selectedIndex,
          selectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          onTap: provider.changeIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.eco), label: "Vegetables"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: "Orders",
            ),
          ],
        ),
      ),
    );
  }
}
