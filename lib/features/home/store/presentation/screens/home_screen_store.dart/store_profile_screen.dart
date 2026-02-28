import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';

import '../../../widgets/store_account_info_seccion.dart';
import '../../../widgets/store_log_out_button.dart';
import '../../../widgets/store_shops_identify.dart';

class StoreProfilePage extends StatefulWidget {
  const StoreProfilePage({super.key});

  @override
  State<StoreProfilePage> createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
  @override
  void initState() {
    super.initState();
    // defer loading until after the first frame to avoid calling
    // provider methods during build
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStoreProfile());
  }

  void _loadStoreProfile() {
    final authProvider = context.read<AuthProvider>();
    final storeProfileProvider = context.read<StoreProfileProvider>();

    if (authProvider.userId != null) {
      storeProfileProvider.fetchStoreProfile(authProvider.userId!);
    }
  }

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
