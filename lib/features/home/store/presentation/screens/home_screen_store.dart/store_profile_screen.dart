import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import '../../../widgets/store_profile_header.dart';
import '../../../widgets/store_profile_identity_card.dart';
import '../../../widgets/store_profile_content.dart';

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
    final authProvider = context.read<AuthViewModel>();
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
              const StoreProfileHeaderSection(),
              const StoreProfileIdentityCard(),
            ],
          ),
          const StoreProfileContent(),
        ],
      ),
    );
  }
}
