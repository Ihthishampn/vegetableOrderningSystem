import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../exports/providers.dart';
import '../exports/repositories.dart';
import '../exports/usecases.dart';

List<ChangeNotifierProvider> createProviders() {
  final firestore = FirebaseFirestore.instance;

  final productRepo = ProductRepositoryImpl(firestore);
  final orderRepo = OrderRepositoryImpl(firestore);
  final storeProfileRepo = StoreProfileRepositoryImpl(firestore);
  final staffRepo = StaffRepositoryImpl(firestore);
  final shopRepo = ShopRepositoryImpl(firestore);
  final salesReportRepo = SalesReportRepositoryImpl(firestore);

  final productUse = ProductUseCase(productRepo);
  final orderUse = OrderUseCase(orderRepo);
  final storeProfileUse = StoreProfileUseCase(storeProfileRepo);
  final staffUse = StaffUseCase(staffRepo);
  final shopUse = ShopUseCase(shopRepo);
  final salesReportUse = SalesReportUseCase(salesReportRepo);

  return [
    ChangeNotifierProvider<EntryProvider>(create: (_) => EntryProvider()),
    ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
    ChangeNotifierProvider<OtpProvider>(create: (_) => OtpProvider()),
    ChangeNotifierProvider<ProductProvider>(
      create: (_) => ProductProvider(productUse),
    ),
    ChangeNotifierProvider<OrderProvider>(
      create: (_) => OrderProvider(orderUse, shopUse),
    ),
    ChangeNotifierProvider<StoreProfileProvider>(
      create: (_) => StoreProfileProvider(storeProfileUse),
    ),
    ChangeNotifierProvider<StaffProvider>(
      create: (_) => StaffProvider(staffUse),
    ),
    ChangeNotifierProvider<ShopProvider>(create: (_) => ShopProvider(shopUse)),
    ChangeNotifierProvider<SalesReportProvider>(
      create: (_) => SalesReportProvider(salesReportUse),
    ),
    ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
  ];
}
