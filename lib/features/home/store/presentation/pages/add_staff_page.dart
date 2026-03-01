import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/add_staff_provider.dart';
import '../widgets/add_staff_form.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_staff/presentation/provider/staff_provider.dart';
import 'package:vegetable_ordering_system/features/store_staff/domain/entities/staff.dart';

class AddStaffPage extends StatelessWidget {
  final Staff? staff;
  const AddStaffPage({super.key, this.staff});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final staffProv = Provider.of<StaffProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) =>
          AddStaffProvider(staffProvider: staffProv, auth: auth, staff: staff),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            staff == null ? 'Add New Staff' : 'Edit Staff',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: const AddStaffForm(),
      ),
    );
  }
}
