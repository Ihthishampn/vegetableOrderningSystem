import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import '../widgets/repeat_last_order_widget/repeat_order_header.dart';
import '../widgets/repeat_last_order_widget/repeat_order_items_list.dart';
import '../widgets/repeat_last_order_widget/repeat_total_items_footer.dart';
import '../widgets/repeat_last_order_widget/repeat_order_actions.dart';

class RepeatLastOrder extends StatelessWidget {
  const RepeatLastOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final titleFontSize = screenWidth > 600 ? 20.0 : 18.0;
    final iconSize = screenWidth > 600 ? 24.0 : 20.0;
    final itemsLabelFontSize = screenWidth > 600 ? 20.0 : 18.0;
    final headerSpacing = screenHeight > 800 ? 28.0 : 24.0;
    final itemsSpacing = screenHeight > 800 ? 20.0 : 16.0;
    const horizontalPadding = 20.0;

    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
    if (orderProv.storeId == null && auth.storeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProv.initialize(auth.storeId!);
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: iconSize),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Previous Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: titleFontSize,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          RepeatOrderHeader(),
          SizedBox(height: headerSpacing),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ordered items",
                    style: TextStyle(
                      fontSize: itemsLabelFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: itemsSpacing),
                  RepeatOrderItemsList(),
                ],
              ),
            ),
          ),
          const TotalItemsFooter(total: "05"),
          RepeatOrderActions(),
        ],
      ),
    );
  }
}
