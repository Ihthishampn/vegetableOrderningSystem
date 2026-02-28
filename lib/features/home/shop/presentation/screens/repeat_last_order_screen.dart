import 'package:flutter/material.dart';

import '../widgets/repeat_last_order_widget/order_action_button.dart';
import '../widgets/repeat_last_order_widget/repeat_card_summary.dart';
import '../widgets/repeat_last_order_widget/repeat_order_item_row.dart';
import '../widgets/repeat_last_order_widget/repeat_total_items_footer.dart';

class RepeatLastOrder extends StatelessWidget {
  const RepeatLastOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Previous Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const OrderSummaryHeader(
            orderId: "ORD1763532470082",
            storeName: "Green Valley Wholesale",
            itemCount: 5,
          ),

          const SizedBox(height: 24),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ordered items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: const [
                        OrderItemRow(
                          index: 1,
                          name: "Ridge gourd",
                          quantity: "20 Kg",
                        ),
                        OrderItemRow(
                          index: 2,
                          name: "Carrot",
                          quantity: "15 Kg",
                        ),
                        OrderItemRow(
                          index: 3,
                          name: "Cauliflower",
                          quantity: "10Kg",
                        ),
                        OrderItemRow(
                          index: 4,
                          name: "Tomato",
                          quantity: "20 Box",
                        ),
                        OrderItemRow(
                          index: 5,
                          name: "Green chili",
                          quantity: "15 Kg",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const TotalItemsFooter(total: "05"),
          const OrderActionButtons(),
        ],
      ),
    );
  }
}

     
