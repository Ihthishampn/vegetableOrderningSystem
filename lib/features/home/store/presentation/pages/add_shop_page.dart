import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_shops/presentation/provider/shop_provider.dart';
import '../provider/add_shop_provider.dart';
import '../widgets/add_shop_form.dart';

class AddShopPage extends StatelessWidget {
  final dynamic
  shop; // keep dynamic to avoid tight coupling in imports; callers pass the Shop
  const AddShopPage({super.key, this.shop});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final shopProv = Provider.of<ShopProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) =>
          AddShopProvider(shopProvider: shopProv, auth: auth, shop: shop),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            shop == null ? 'Add New Shop' : 'Edit Shop Details',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: const AddShopForm(),
      ),
    );
  }
}
