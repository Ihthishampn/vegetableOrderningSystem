import 'package:flutter/material.dart';

import '../widgets/order_in_advance/advance_bottom_action_button.dart';
import '../widgets/order_in_advance/advance_date_icker.dart';
import '../widgets/order_in_advance/advance_order_product_card.dart';
import '../widgets/order_in_advance/advance_seaerch_bar.dart';

class OrderInAdvanceScreen extends StatelessWidget {
  const OrderInAdvanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 20,
        ),),
        title: const Text(
          "Schedule Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          //  Date Picker Field
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DatePickerField(initialDate: "12-02-2026"),
          ),

          //  Search Bar
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ProductSearchBar(),
          ),

          //  Product List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: const [
                OrderProductCard(
                  name: "Carrot",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/2347/2347031.png", // Example image
                  units: ["kg", "Bag"],
                ),
                OrderProductCard(
                  name: "Green chili",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/7230/7230868.png",
                  units: ["kg", "Box", "Bag"],
                ),
                OrderProductCard(
                  name: "Tomato",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/1202/1202125.png",
                  units: ["kg", "Box", "Bag"],
                ),
                OrderProductCard(
                  name: "Okra",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/5346/5346453.png",
                  units: ["kg"],
                ),
                OrderProductCard(
                  name: "Beans",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/2347/2347040.png",
                  units: ["kg"],
                ),
              ],
            ),
          ),

          // 4. Bottom Actions
          const BottomActionButtons(),
        ],
      ),
    );
  }
}



