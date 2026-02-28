import 'package:flutter/material.dart';

import '../widgets/pendings_widgets/edit_order_button.dart';
import '../widgets/pendings_widgets/pending_action_footer.dart';
import '../widgets/pendings_widgets/pending_order_info_card.dart';
import '../widgets/pendings_widgets/pending_order_item_list.dart';

class PendingOrderOverview extends StatelessWidget {
  const PendingOrderOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: (){

//  navigation logic

          }, 
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            OrderInfoCard(), 
            SizedBox(height: 30),
            Text(
              "Ordered items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            OrderedItemsList(), 
            SizedBox(height: 20),
            EditOrderButton(),
          ],
        ),
      ),
      bottomNavigationBar: const PendingActionFooter(),
    );
  }
}

