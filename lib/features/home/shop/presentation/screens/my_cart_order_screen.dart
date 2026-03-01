import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
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
  DateTime? _selectedDate;
  String get _dateLabel {
    if (_selectedDate == null) return 'Filter by Date';
    return "${_selectedDate!.day.toString().padLeft(2, '0')}-"
        "${_selectedDate!.month.toString().padLeft(2, '0')}-"
        "${_selectedDate!.year}";
  }

  List<String> _stores = ['All'];
  final Map<String, String> _storeIdByName = {};

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

  Future<void> _loadStores() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'store')
          .get();
      final names = <String>[];
      for (final d in snapshot.docs) {
        final data = d.data();
        final name = ((data['storename'] ?? data['storeName']) as String?)?.trim();
        final displayName = (name != null && name.isNotEmpty) ? name : d.id;
        names.add(displayName);
        _storeIdByName[displayName] = d.id;
      }
      setState(() {
        _stores = ['All', ...names];
      });
    } catch (e) {
      // 
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    _loadStores();
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
            stores: _stores,
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
          OrderTypeToggle(
            selectedIndex: selectedMainTab,
            onChanged: (index) => setState(() => selectedMainTab = index),
          ),

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
                Expanded(
                  child: FilterDropdown(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    label: _dateLabel,
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

                if (selectedStore != 'All') {
                  final id = _storeIdByName[selectedStore];
                  if (id != null) {
                    filtered = filtered.where((o) => o.storeId == id).toList();
                  } else {
                    filtered = [];
                  }
                }

                if (_selectedDate != null) {
                  filtered = filtered.where((o) {
                    final dt = o.scheduledDate ?? o.createdAt;
                    return dt.year == _selectedDate!.year &&
                        dt.month == _selectedDate!.month &&
                        dt.day == _selectedDate!.day;
                  }).toList();
                }

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
