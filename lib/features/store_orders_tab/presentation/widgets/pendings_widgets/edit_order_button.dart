import 'package:flutter/material.dart';

import 'pending_outln_widget.dart';

class EditOrderButton extends StatelessWidget {
  const EditOrderButton({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: OutlineBtn(text: "Edit Order", color: Colors.black54),
  );
}
