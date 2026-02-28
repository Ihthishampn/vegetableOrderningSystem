import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/auth/auth_store/presentation/widgets/store_login_form.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/shop_home_screen.dart';

class LoginScreenShop extends StatelessWidget {
  const LoginScreenShop({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset("assets/images/no_bg.png"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD4DCFF),
              Color.fromARGB(0, 255, 255, 255),
              Color(0xFFD4DCFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.05),
                  child: Image.asset(
                    "assets/images/login_shop_image.png",
                    width: size.width * 0.8,
                    fit: BoxFit.contain,
                    height: size.height * 0.35,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: LoginFormStore(
                  size: size,
                  role: 'shop',
                  titleColor: Colors.green,
                  labelColor: Colors.black,
                  successScreen: const ShopHomeScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
