import 'package:flutter/widgets.dart';
import 'package:vegetable_ordering_system/features/home_store/store/presentation/screens/store_home_screen.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/screens/store_orders_screen.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/screens/store_vegetable_screens.dart';

class EntryProvider with ChangeNotifier {
  List<Widget> widgetStack = [
    StoreHomeScreen(),
    StoreVegetableScreens(),
    StoreOrdersScreen(),
  ];
  int selectedIndex = 0;

  void changeIndex(int index) {
    if (index == selectedIndex) return;
    selectedIndex = index;
    notifyListeners();
  }
}

