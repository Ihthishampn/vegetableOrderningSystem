import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/auth/auth_store/presentation/widgets/login_title_store.dart';
import 'package:vegetable_ordering_system/features/auth/auth_store/presentation/widgets/mobile_input_store.dart';
import 'package:vegetable_ordering_system/features/auth/auth_store/presentation/widgets/mobile_label_store.dart';
import 'package:vegetable_ordering_system/features/auth/auth_store/presentation/widgets/send_otp_store_button.dart';

import '../../../../../core/widgets/otp_verification_sheet.dart';

class LoginScreenShop extends StatelessWidget {
  const LoginScreenShop({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white, // make body gradient visible
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
            ),
            child: Column(
              children: [
                Expanded(child: image(size)),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoginTitleStore(
                      blueOrgreen: Colors.green,
                      whiteOrblack: Colors.black,
                    ),
                    const SizedBox(height: 24),
                    MobileLabel(color: Colors.black),
                    const SizedBox(height: 8),
                    MobileInput(),
                    const SizedBox(height: 12),
                    // Inside your Column in LoginScreenShop
                    SendOtpButton(
                      isStore: false,
                      ontap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled:
                              true, // Allows sheet to move up with keyboard
                          backgroundColor: Colors.transparent,
                          builder: (context) => const OtpVerificationSheet(),
                        );
                      },
                    ),
                    const SizedBox(height: 19),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget image(Size size) {
    return Center(
      child: Image.asset(
        "assets/images/login_shop_image.png",
        width: size.width * 0.8,
        fit: BoxFit.contain,
      ),
    );
  }
}

