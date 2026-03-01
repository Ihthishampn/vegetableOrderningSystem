import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_in_advance_screen.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/shop_home_widget/shop_header.dart';
import '../widgets/shop_home_widget/shop_search_widget.dart';
import '../widgets/shop_home_widget/shop_address_row.dart';
import '../widgets/shop_home_widget/shop_action_banner.dart';
import '../widgets/shop_home_widget/shop_product_list.dart';
import '../widgets/shop_home_widget/shop_bottom_order_button.dart';
import 'repeat_last_order_screen.dart';

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({super.key});

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  late CartProvider _localCartProvider;
  String _storeNameFromFirebase = '';
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _localCartProvider = CartProvider();
    _loadStoreNameFromFirebase();
  }

  Future<void> _loadStoreNameFromFirebase() async {
    try {
      final auth = Provider.of<AuthViewModel>(context, listen: false);
      if (auth.storeId != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.storeId!)
            .get();
        if (doc.exists) {
          final data = doc.data();
          final name = ((data?['shopName'] ?? data?['storeName']) as String?)
              ?.trim();
          if (mounted && name != null && name.isNotEmpty) {
            setState(() {
              _storeNameFromFirebase = name;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading store name: $e');
    }
  }

  @override
  void dispose() {
    _localCartProvider.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _localCartProvider,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {},
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 80.0,
                collapsedHeight: 80.0,
                toolbarHeight: 80.0,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: const FlexibleSpaceBar(background: ShopHeader()),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 1),
                    ShopAddressRow(
                      storeNameFromFirebase: _storeNameFromFirebase,
                    ),
                    const SizedBox(height: 1),
                    ShopActionBanner(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderInAdvanceScreen(),
                          ),
                        );
                      },
                      icon: Icons.history,
                      text: "Order in advance.",
                      color: const Color(0xFFFFF9E5),
                      iconColor: const Color.fromARGB(255, 136, 82, 1),
                    ),
                    const SizedBox(height: 8),
                    ShopActionBanner(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RepeatLastOrder(),
                        ),
                      ),
                      icon: Icons.refresh,
                      text: "Repeat the last order.",
                      color: const Color(0xFFE8F5E9),
                      iconColor: const Color.fromARGB(255, 58, 134, 61),
                    ),
                    const SizedBox(height: 8),
                    SearchBarWidget(
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
                    const SizedBox(height: 7),
                    ShopProductList(searchTerm: _searchTerm),
                    const SizedBox(height: 10),
                  ]),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ShopBottomOrderButton(
            cartProvider: _localCartProvider,
          ),
        ),
      ),
    );
  }
}
