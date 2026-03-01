import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_in_advance_screen.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_now_screen.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/repeat_last_order_screen.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/shop_home_widget/shop_header.dart';
import '../widgets/shop_home_widget/shop_product_card.dart';
import '../widgets/shop_home_widget/shop_search_widget.dart';

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
          final name = ((data?['storename'] ?? data?['storeName']) as String?)
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
                    _buildAddressRow(context),
                    const SizedBox(height: 1),

                    _buildActionBanner(
                      ontap: () {
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
                    _buildActionBanner(
                      ontap: () => Navigator.of(context).push(
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
                    _buildProductList(),
                    const SizedBox(height: 10),
                  ]),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomOrderButton(context),
        ),
      ),
    );
  }

  Widget _buildAddressRow(BuildContext context) {
    final profile = Provider.of<StoreProfileProvider>(context, listen: false);
    final storeName = _storeNameFromFirebase.isNotEmpty
        ? _storeNameFromFirebase
        : (profile.storeProfile?.storeName ?? 'Your Store');
    final address = profile.storeProfile?.address;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            address != null && address.isNotEmpty
                ? '$storeName, $address'
                : storeName,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'You have already selected a store. You cannot change the store right now.',
                ),
              ),
            );
          },
          child: const Text(
            "Change store",
            style: TextStyle(color: Color(0xFF5C79FF)),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final auth = Provider.of<AuthViewModel>(context, listen: false);
        final orderProvider = Provider.of<OrderProvider>(
          context,
          listen: false,
        );
        if (productProvider.storeId == null && auth.storeId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            productProvider.initialize(auth.storeId!);
            orderProvider.initialize(auth.storeId!);
          });
        }

        if (productProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (productProvider.error != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('Error: ${productProvider.error}')),
          );
        }

        // apply search filter if provided
        var products = List<Product>.from(productProvider.allProducts);
        if (_searchTerm.isNotEmpty) {
          products = products
              .where(
                (p) => p.name.toLowerCase().contains(_searchTerm.toLowerCase()),
              )
              .toList();
        }
        products.sort((a, b) {
          final avA = a.isAvailable ? 0 : 1;
          final avB = b.isAvailable ? 0 : 1;
          return avA.compareTo(avB);
        });

        if (products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('No products available')),
          );
        }

        return Column(
          children: products
              .map(
                (product) => ProductCard(
                  product: product,
                  name: product.name,
                  image: product.imageUrl ?? "assets/placeholder.png",
                  units: [product.unit],
                  isOutOfStock: !product.isAvailable,
                  onAddToCart: !product.isAvailable
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildActionBanner({
    required VoidCallback ontap,
    required IconData icon,
    required String text,
    required Color color,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: iconColor.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomOrderButton(BuildContext c) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(c).push(
            MaterialPageRoute(
              builder: (context) =>
                  OrderNowScreen(cartProvider: _localCartProvider),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        label: const Text(
          "Order Now",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C79FF),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
