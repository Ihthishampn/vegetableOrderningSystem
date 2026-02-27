import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/entry/store/presentation/nav_bar/entry.dart';
import 'package:vegetable_ordering_system/features/entry/store/presentation/provider/entry_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider<EntryProvider>(create: (context) => EntryProvider())],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Entry());
  }
}
