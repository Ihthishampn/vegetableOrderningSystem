import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import '../widgets/order_in_advance/advance_date_icker.dart';
import '../widgets/shop_home_widget/shop_search_widget.dart';
import '../widgets/order_in_advance/advance_order_product_list.dart';
import '../widgets/order_in_advance/advance_order_actions.dart';

class OrderInAdvanceScreen extends StatefulWidget {
  const OrderInAdvanceScreen({super.key});

  @override
  State<OrderInAdvanceScreen> createState() => _OrderInAdvanceScreenState();
}

class _OrderInAdvanceScreenState extends State<OrderInAdvanceScreen> {
  DateTime _pickedDate = DateTime.now().add(const Duration(days: 2));
  late TextEditingController _searchController;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _dateText {
    return "${_pickedDate.day.toString().padLeft(2, '0')}-"
        "${_pickedDate.month.toString().padLeft(2, '0')}-"
        "${_pickedDate.year}";
  }

  Future<void> _selectDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _pickedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newDate != null) {
      setState(() {
        _pickedDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? screenWidth * 0.05 : 16.0;
    final verticalPadding = 8.0;
    final titleFontSize = screenWidth > 600 ? 20.0 : 18.0;
    final iconSize = screenWidth > 600 ? 24.0 : 20.0;

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
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: iconSize),
        ),
        title: Text(
          "Schedule Order",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: DatePickerField(
              initialDate: _dateText,
              onTap: _selectDate,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchTerm = val.trim();
                });
              },
              onClear: () {
                setState(() {
                  _searchTerm = '';
                });
              },
            ),
          ),
          AdvanceOrderProductList(searchTerm: _searchTerm),
          AdvanceOrderActions(scheduledDate: _pickedDate),
        ],
      ),
    );
  }
}
