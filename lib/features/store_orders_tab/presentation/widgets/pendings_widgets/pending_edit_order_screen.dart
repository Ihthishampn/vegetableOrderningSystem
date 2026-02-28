import 'package:flutter/material.dart';

import 'edit_item_card.dart';
import 'save_action_footer.dart';

class EditOrderScreen extends StatelessWidget {
  const EditOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light background for cards
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Based on your shared image
        itemBuilder: (context, index) {
          final items = [
            {
              'name': 'carrot',
              'img': 'https://cdn-icons-png.flaticon.com/512/2316/2316652.png',
            },
            {
              'name': 'green chili',
              'img': 'https://cdn-icons-png.flaticon.com/512/4054/4054632.png',
            },
            {
              'name': 'tomato',
              'img': 'https://cdn-icons-png.flaticon.com/512/1202/1202125.png',
            },
            {
              'name': 'okra',
              'img': 'https://cdn-icons-png.flaticon.com/512/6129/6129038.png',
            },
            {
              'name': 'bean',
              'img': 'https://cdn-icons-png.flaticon.com/512/4021/4021810.png',
            },
          ];
          return EditItemCard(
            name: items[index]['name']!,
            imageUrl: items[index]['img']!,
          );
        },
      ),
      bottomNavigationBar: const SaveActionFooter(),
    );
  }
}
