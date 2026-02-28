import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/entry/store/presentation/provider/entry_provider.dart';
import 'package:vegetable_ordering_system/features/entry/splash_session_check.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/providers/otp_provider.dart';
import 'package:vegetable_ordering_system/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/data/repositories/product_repository_impl.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/usecases/product_use_case.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/data/repositories/order_repository_impl.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/usecases/order_use_case.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/store_profile/data/repositories/store_profile_repository_impl.dart';
import 'package:vegetable_ordering_system/features/store_profile/domain/usecases/store_profile_use_case.dart';
import 'package:vegetable_ordering_system/features/store_profile/presentation/provider/store_profile_provider.dart';
import 'package:vegetable_ordering_system/features/store_staff/data/repositories/staff_repository_impl.dart';
import 'package:vegetable_ordering_system/features/store_staff/domain/usecases/staff_use_case.dart';
import 'package:vegetable_ordering_system/features/store_staff/presentation/provider/staff_provider.dart';
import 'package:vegetable_ordering_system/features/store_shops/data/repositories/shop_repository_impl.dart';
import 'package:vegetable_ordering_system/features/store_shops/domain/usecases/shop_use_case.dart';
import 'package:vegetable_ordering_system/features/store_shops/presentation/provider/shop_provider.dart';
import 'package:vegetable_ordering_system/features/sales_report/data/repositories/sales_report_repository_impl.dart';
import 'package:vegetable_ordering_system/features/sales_report/domain/usecases/sales_report_use_case.dart';
import 'package:vegetable_ordering_system/features/sales_report/presentation/provider/sales_report_provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EntryProvider>(
          create: (context) => EntryProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<OtpProvider>(create: (context) => OtpProvider()),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(
            ProductUseCase(ProductRepositoryImpl(FirebaseFirestore.instance)),
          ),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(
            OrderUseCase(OrderRepositoryImpl(FirebaseFirestore.instance)),
          ),
        ),
        ChangeNotifierProvider<StoreProfileProvider>(
          create: (context) => StoreProfileProvider(
            StoreProfileUseCase(
              StoreProfileRepositoryImpl(FirebaseFirestore.instance),
            ),
          ),
        ),
        ChangeNotifierProvider<StaffProvider>(
          create: (context) => StaffProvider(
            StaffUseCase(StaffRepositoryImpl(FirebaseFirestore.instance)),
          ),
        ),
        ChangeNotifierProvider<ShopProvider>(
          create: (context) => ShopProvider(
            ShopUseCase(ShopRepositoryImpl(FirebaseFirestore.instance)),
          ),
        ),
        ChangeNotifierProvider<SalesReportProvider>(
          create: (context) => SalesReportProvider(
            SalesReportUseCase(
              SalesReportRepositoryImpl(FirebaseFirestore.instance),
            ),
          ),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashSessionCheck(),
    );
  }
}
