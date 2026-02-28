import 'package:flutter/material.dart';

import '../widgets/order_now_widgets/now_confirm_order_button.dart';
import '../widgets/order_now_widgets/now_summary.dart';
import '../widgets/order_now_widgets/now_summury_item_row.dart';
import '../widgets/order_now_widgets/now_total_item_banner.dart';

class OrderNowScreen extends StatelessWidget {
  const OrderNowScreen({super.key});

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
          "Summary",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Highlighted Summary Card
          const OrderSummaryCard(
            orderId: "ORD1763532470082",
            storeName: "Green Valley Wholesale",
            itemCount: 5,
          ),

          const SizedBox(height: 24),

          // Ordered Items Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        SummaryItemRow(label: "1 Ridge gourd", quantity: "20 Kg"),
                        SummaryItemRow(label: "2 Carrot", quantity: "15 Kg"),
                        SummaryItemRow(label: "3 Cauliflower", quantity: "10Kg"),
                        SummaryItemRow(label: "4 Tomato", quantity: "20 Box"),
                        SummaryItemRow(label: "5 Green chili", quantity: "15 Kg"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //  Total Items Calculation
          const TotalItemsBanner(total: "05"),

          //  Final Confirmation Button
          const ConfirmOrderButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}



