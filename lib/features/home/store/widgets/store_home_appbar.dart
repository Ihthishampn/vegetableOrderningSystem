import 'package:flutter/material.dart';
import 'circular_icon_widget.dart';
import 'top_home_appbar_content_store.dart';
import '../presentation/screens/home_screen_store.dart/store_menu_screen.dart';
import '../presentation/screens/home_screen_store.dart/store_profile_screen.dart';

class StoreHomeAppBar extends StatelessWidget {
  final double expandedHeight;

  const StoreHomeAppBar({
    super.key,
    required this.expandedHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      backgroundColor: Colors.transparent,
      actions: [
        CircularIcon(
          icon: Icons.menu,
          ontap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          },
        ),
        CircularIcon(
          icon: Icons.person_outline,
          ontap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => StoreProfilePage()),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: TopAppBarContent(size: MediaQuery.of(context).size),
      ),
    );
  }
}
