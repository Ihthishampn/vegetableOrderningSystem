import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/widgets/shop_home_widget/shop_product_card.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';

import '../widgets/order_in_advance/advance_date_icker.dart';
import '../widgets/shop_home_widget/shop_search_widget.dart';

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

          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                if (productProvider.storeId == null && auth.storeId != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    productProvider.initialize(auth.storeId!);
                  });
                }

                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (productProvider.error != null) {
                  return Center(child: Text('Error: ${productProvider.error}'));
                }
                final products = productProvider.availableProducts.isEmpty
                    ? productProvider.allProducts
                    : productProvider.availableProducts;

                // apply search filter
                var filteredProducts = List.from(products);
                if (_searchTerm.isNotEmpty) {
                  filteredProducts = filteredProducts
                      .where(
                        (p) => p.name.toLowerCase().contains(
                          _searchTerm.toLowerCase(),
                        ),
                      )
                      .toList();
                }

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('No products available'));
                }
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: filteredProducts
                      .map(
                        (product) => ProductCard(
                          product: product,
                          name: product.name,
                          image: product.imageUrl ?? 'assets/placeholder.png',
                          units: [product.unit],
                          isOutOfStock: !product.isAvailable,
                          onAddToCart: !product.isAvailable
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} added'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final cart = Provider.of<CartProvider>(
                        context,
                        listen: false,
                      );
                      cart.clearCart();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final cart = Provider.of<CartProvider>(
                        context,
                        listen: false,
                      );
                      if (cart.cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Your cart is empty. Add items before placing a scheduled order.',
                            ),
                          ),
                        );
                        return;
                      }

                      final authLocal = Provider.of<AuthViewModel>(
                        context,
                        listen: false,
                      );
                      final orderProvLocal = Provider.of<OrderProvider>(
                        context,
                        listen: false,
                      );
                      final profileProvLocal =
                          Provider.of<StoreProfileProvider>(
                            context,
                            listen: false,
                          );

                      if (orderProvLocal.storeId == null &&
                          authLocal.storeId != null) {
                        await orderProvLocal.initialize(authLocal.storeId!);
                      }

                      final storeId =
                          orderProvLocal.storeId ?? authLocal.storeId;
                      final customerId = authLocal.uid;
                      if (storeId == null || storeId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Store ID missing. Cannot place order.',
                            ),
                          ),
                        );
                        return;
                      }
                      if (customerId == null || customerId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'User not authenticated. Please log in.',
                            ),
                          ),
                        );
                        return;
                      }

                      String customerName = authLocal.storeName?.trim() ?? '';
                      if (customerName.isEmpty) {
                        customerName =
                            profileProvLocal.storeProfile?.storeName?.trim() ??
                            '';
                      }
                      if (customerName.isEmpty) customerName = storeId;

                      String deliveryAddress =
                          profileProvLocal.storeProfile?.address ?? '';
                      String customerPhone = authLocal.userRole == 'store'
                          ? authLocal.phoneNumber ?? ''
                          : '';

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Placing scheduled order...'),
                        ),
                      );

                      bool success = false;
                      try {
                        success = await orderProvLocal.addOrder(
                          customerId: customerId,
                          customerName: customerName,
                          customerPhone: customerPhone,
                          deliveryAddress: deliveryAddress,
                          items: cart.cartItems
                              .map(
                                (c) => OrderItem(
                                  productId: c.product.id,
                                  productName: c.product.name,
                                  price: 0.0,
                                  quantity: c.quantity,
                                  unit: c.selectedUnit,
                                  subtotal: 0.0,
                                ),
                              )
                              .toList(),
                          totalPrice: 0.0,
                          scheduledDate: _pickedDate,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error placing order: $e')),
                          );
                        }
                        success = false;
                      }

                      if (!context.mounted) return;

                      if (success) {
                        cart.clearCart();
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.black54,
                          transitionDuration: const Duration(milliseconds: 400),
                          pageBuilder: (_, __, ___) => const AddSuccessDialog(
                            title: "Scheduled",
                            message: "Your scheduled order has been placed.",
                          ),
                          transitionBuilder: (_, anim, __, child) =>
                              ScaleTransition(
                                scale: CurvedAnimation(
                                  parent: anim,
                                  curve: Curves.easeOutBack,
                                ),
                                child: child,
                              ),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          if (!context.mounted) return;
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to place order: ${orderProvLocal.error}',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B7FFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Order",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
