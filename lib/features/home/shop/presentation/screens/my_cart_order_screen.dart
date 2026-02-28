import 'package:flutter/material.dart';
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
            child: selectedMainTab == 0
                ? const ScheduledOrdersList()
                : const DirectOrdersList(),
          ),
        ],
      ),
    );
  }
}

