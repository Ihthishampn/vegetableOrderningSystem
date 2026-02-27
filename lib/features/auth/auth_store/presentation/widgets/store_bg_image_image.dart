import 'package:flutter/widgets.dart';

class StoreBackgroundImage extends StatelessWidget {
  const StoreBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_store_bottom_bg_image.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
