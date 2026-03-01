import 'package:flutter/material.dart';
import 'store_account_info_seccion.dart';
import 'store_log_out_button.dart';

class StoreProfileContent extends StatelessWidget {
  const StoreProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
     
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 100),
        const StoreAccountInfoSection(),
      
        const SizedBox(height: 24),
        const StoreLogoutButton(),
        const SizedBox(height: 50),
      ],
    );
  }
}
