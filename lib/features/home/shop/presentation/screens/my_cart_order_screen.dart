import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/widgets/cart_widgets/order_type_toggle.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/widgets/cart_widgets/status_filter_bar.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/widgets/cart_widgets/store_dropdowm_menu.dart';

import '../widgets/cart_widgets/direct_order_list.dart';
import '../widgets/cart_widgets/filter_drop_down.dart';
import '../widgets/cart_widgets/my_shedule_order_list.dart';

class MyCartOrdersScreen extends StatefulWidget {
  const MyCartOrdersScreen({super.key});

  @override
  State<MyCartOrdersScreen> createState() => _MyCartOrdersScreenState();
}

class _MyCartOrdersScreenState extends State<MyCartOrdersScreen> {
  int selectedMainTab = 0;
  String selectedStatus = 'All';
  String selectedStore = 'All';

  final LayerLink _storeLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _closeDropdown();
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 32,
        child: CompositedTransformFollower(
          link: _storeLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: StoreDropdownMenu(
            selectedStore: selectedStore,
            onStoreSelected: (name) {
              setState(() => selectedStore = name);
              _closeDropdown();
            },
            onClose: _closeDropdown,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ensure order provider is initialized with supplier id
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
    if (orderProv.storeId == null && authProv.storeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProv.initialize(authProv.storeId!);
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          //  Tab Switcher
          OrderTypeToggle(
            selectedIndex: selectedMainTab,
            onChanged: (index) => setState(() => selectedMainTab = index),
          ),

          //Dropdown Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: CompositedTransformTarget(
                    link: _storeLink,
                    child: FilterDropdown(
                      label: selectedStore == 'All'
                          ? "Filter by Store"
                          : selectedStore,
                      icon: Icons.filter_list,
                      onTap: _toggleDropdown,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: FilterDropdown(
                    onTap: null,
                    label: "Filter by Date",
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              ],
            ),
          ),

          StatusFilterBarCart(
            selectedStatus: selectedStatus,
            onStatusSelected: (status) =>
                setState(() => selectedStatus = status),
          ),

          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, orderProv, _) {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                // only show orders for this customer
                final customerOrders = orderProv.allOrders
                    .where((o) => o.customerId == auth.uid)
                    .cast<Order>()
                    .toList();

                // apply status filter if not 'All'
                List<Order> filtered = customerOrders;
                if (selectedStatus != 'All') {
                  filtered = filtered
                      .where(
                        (o) =>
                            o.status.toString().split('.').last.toLowerCase() ==
                            selectedStatus.toLowerCase(),
                      )
                      .toList();
                }

                // For simplicity we ignore store dropdown filter – all orders belong to same supplier

                // split based on scheduled date: scheduled orders are those with scheduledDate in future
                final now = DateTime.now();
                final scheduledOrders = filtered.where((o) {
                  final sd = o.scheduledDate;
                  return sd != null && sd.isAfter(now);
                }).toList();
                final directOrders = filtered.where((o) {
                  final sd = o.scheduledDate;
                  return sd == null ||
                      sd.isBefore(now) ||
                      sd.isAtSameMomentAs(now);
                }).toList();

                if (selectedMainTab == 0) {
                  return ScheduledOrdersList(orders: scheduledOrders);
                } else {
                  return DirectOrdersList(orders: directOrders);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
