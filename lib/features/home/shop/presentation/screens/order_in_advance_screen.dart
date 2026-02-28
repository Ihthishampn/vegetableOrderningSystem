import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/widgets/shop_home_widget/shop_product_card.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';

import '../widgets/order_in_advance/advance_date_icker.dart';
import '../widgets/order_in_advance/advance_seaerch_bar.dart';

class OrderInAdvanceScreen extends StatefulWidget {
  const OrderInAdvanceScreen({super.key});

  @override
  State<OrderInAdvanceScreen> createState() => _OrderInAdvanceScreenState();
}

class _OrderInAdvanceScreenState extends State<OrderInAdvanceScreen> {
  DateTime _pickedDate = DateTime.now();

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
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);

    // ensure order provider initialized with the supplier id
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
          // date picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DatePickerField(initialDate: _dateText, onTap: _selectDate),
          ),

          // search bar (optional)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ProductSearchBar(),
          ),

          // product list very similar to shop_home
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
                if (products.isEmpty) {
                  return const Center(child: Text('No products available'));
                }
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: products
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
                                  cart.addToCart(product, 1, product.unit);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} added'),
                                      duration: const Duration(seconds: 2),
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

          // bottom action
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
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
                      if (cart.cartItems.isEmpty) return;
                      // reuse confirm logic from ConfirmOrderButton
                      final profileProv = Provider.of<StoreProfileProvider>(
                        context,
                        listen: false,
                      );
                      String customerName = '';
                      String deliveryAddress = '';
                      String customerPhone = auth.phoneNumber ?? '';
                      if (profileProv.storeProfile != null) {
                        customerName = profileProv.storeProfile!.storeName;
                        deliveryAddress = profileProv.storeProfile!.address;
                      }
                      final success = await orderProv.addOrder(
                        customerId: auth.uid ?? '',
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
                      if (success) {
                        cart.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Scheduled order placed'),
                          ),
                        );
                        Navigator.of(context).pop();
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
