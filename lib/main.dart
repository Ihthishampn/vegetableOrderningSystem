import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/entry/store/presentation/provider/entry_provider.dart';
import 'package:vegetable_ordering_system/firebase_options.dart';

import 'app/role_slect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EntryProvider>(
          create: (context) => EntryProvider(),
        ), ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
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

      
       home: RoleSelect()
    );
  }
}
