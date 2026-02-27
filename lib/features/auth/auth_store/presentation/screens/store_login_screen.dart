import 'package:flutter/material.dart';

import '../widgets/store_bg_image_image.dart';
import '../widgets/store_login_form.dart';

class StoreLoginScreen extends StatelessWidget {
  const StoreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: size.height * 0.25, // responsive height
        title: SafeArea(
          child: Image.asset(
            "assets/images/no_bg.png",
            height: size.height * 0.75,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Stack(
        children: [
          const StoreBackgroundImage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: LoginFormStore(size: size),
          ),
        ],
      ),
    );
  }
}


