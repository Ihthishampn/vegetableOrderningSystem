import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_in_advance_screen.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_now_screen.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/repeat_last_order_screen.dart';
import '../widgets/shop_home_widget/shop_header.dart';
import '../widgets/shop_home_widget/shop_product_card.dart';
import '../widgets/shop_search_widget.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            flexibleSpace: const FlexibleSpaceBar(background: ShopHeader()),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 1),
                _buildAddressRow(),
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
                    MaterialPageRoute(builder: (context) => RepeatLastOrder()),
                  ),
                  icon: Icons.refresh,
                  text: "Repeat the last order.",
                  color: const Color(0xFFE8F5E9),
                  iconColor: const Color.fromARGB(255, 58, 134, 61),
                ),
                const SizedBox(height: 8),

                const SearchBarWidget(),
                const SizedBox(height: 7),
                const ProductCard(
                  name: "Carrot",
                  image: "assets/carrot.png",
                  units: ["kg", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const ProductCard(
                  name: "Tomato",
                  image: "assets/tomato.png",
                  units: ["kg", "Box", "Bag"],
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomOrderButton(context),
    );
  }

  Widget _buildAddressRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            "Veg Graam, 12, Vegetable Market...",
            style: TextStyle(fontSize: 13, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Change store",
            style: TextStyle(color: Color(0xFF5C79FF)),
          ),
        ),
      ],
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
          Navigator.of(
            c,
          ).push(MaterialPageRoute(builder: (context) => OrderNowScreen()));
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
