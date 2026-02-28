import 'package:flutter/material.dart';

import '../../../widgets/store_account_info_seccion.dart';
import '../../../widgets/store_log_out_button.dart';
import '../../../widgets/store_shops_identify.dart';

class StoreProfilePage extends StatelessWidget {
  const StoreProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2926),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, right: 40),
                            child: Text(
                              "Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 110,
                left: 20,
                right: 20,
                child: const ShopIdentityCard(),
              ),
            ],
          ),
          const SizedBox(height: 100),
          const StoreAccountInfoSection(),
          const Spacer(),
          const StoreLogoutButton(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

