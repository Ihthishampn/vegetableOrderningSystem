import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/core/di/providers_injection.dart';
import 'package:vegetable_ordering_system/features/entry/splash_session_check.dart';
import 'package:vegetable_ordering_system/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: createProviders(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //  home: const SplashSessionCheck(),
      home: SplashSessionCheck(),
    );
  }
}
