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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DatePickerField(initialDate: _dateText, onTap: _selectDate),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
