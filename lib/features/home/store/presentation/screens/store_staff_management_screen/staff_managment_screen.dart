import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../store_vegetables_tab/presentation/widgets/add_success_message.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/store_staff/presentation/provider/staff_provider.dart';
import 'package:vegetable_ordering_system/features/store_staff/domain/entities/staff.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final staffProv = Provider.of<StaffProvider>(context, listen: false);
      if (auth.uid != null) {
        staffProv.initialize(auth.uid!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Staff",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Consumer<StaffProvider>(
            builder: (context, staffProv, _) {
              if (staffProv.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (staffProv.error != null) {
                return Center(child: Text('Error: \\${staffProv.error}'));
              }
              final staffList = staffProv.staffList;
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                itemCount: staffList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildStaffCard(staffList[index]);
                },
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddStaffPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2926),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "+ Add New Staff",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(Staff staff) {
    bool active = staff.isActive;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            staff.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildInfoRow("Phone", staff.phone),
          _buildInfoRow("Email", staff.email),
          _buildInfoRow("Position", staff.position),
          _buildInfoRow(
            "Joined",
            "${staff.dateOfJoining.day}/${staff.dateOfJoining.month}/${staff.dateOfJoining.year}",
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 32,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddStaffPage(staff: staff),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 32,
                padding: const EdgeInsets.only(left: 10, right: 2),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: active
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      active ? "Active" : "Inactive",
                      style: TextStyle(
                        color: active ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Transform.scale(
                      scale: 0.65,
                      child: Switch(
                        value: active,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (val) async {
                          final provider = Provider.of<StaffProvider>(
                            context,
                            listen: false,
                          );
                          await provider.toggleStaffStatus(staff.id, val);
                        },
                        activeColor: Colors.green,
                        activeTrackColor: Colors.green.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class AddStaffPage extends StatefulWidget {
  final Staff? staff;
  const AddStaffPage({super.key, this.staff});
  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _positionController;
  late final TextEditingController _addressController;
  DateTime? _dateOfJoining;
  bool _isLoading = false;

  bool get isEdit => widget.staff != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff?.name ?? '');
    _phoneController = TextEditingController(text: widget.staff?.phone ?? '');
    _emailController = TextEditingController(text: widget.staff?.email ?? '');
    _positionController = TextEditingController(
      text: widget.staff?.position ?? '',
    );
    _addressController = TextEditingController(
      text: widget.staff?.address ?? '',
    );
    _dateOfJoining = widget.staff?.dateOfJoining;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF2D2926)),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfJoining ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfJoining = picked;
      });
    }
  }

  Future<void> _submit() async {
    final provider = Provider.of<StaffProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.uid == null) return;
    final now = DateTime.now();
    final staff = Staff(
      id: widget.staff?.id ?? '',
      storeId: auth.uid!,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      position: _positionController.text.trim(),
      address: _addressController.text.trim(),
      idProof: widget.staff?.idProof,
      dateOfJoining: _dateOfJoining ?? now,
      isActive: widget.staff?.isActive ?? true,
      createdAt: widget.staff?.createdAt ?? now,
      updatedAt: now,
    );
    setState(() => _isLoading = true);
    final success = isEdit
        ? await provider.updateStaff(staff)
        : await provider.addStaff(staff);
    setState(() => _isLoading = false);
    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddSuccessDialog(
          title: isEdit ? "Staff Updated" : "Added New Staff",
          message: isEdit
              ? "The staff details have been successfully updated."
              : "The staff member has been successfully added.",
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? "Edit Staff" : "Add New Staff",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Name *"),
              TextField(
                controller: _nameController,
                decoration: _inputDecoration("Enter staff name"),
              ),
              const SizedBox(height: 12),
              _buildLabel("Phone"),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Enter phone number"),
              ),
              const SizedBox(height: 12),
              _buildLabel("Email"),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Enter email"),
              ),
              const SizedBox(height: 12),
              _buildLabel("Position"),
              TextField(
                controller: _positionController,
                decoration: _inputDecoration("Enter position"),
              ),
              const SizedBox(height: 12),
              _buildLabel("Address"),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: _inputDecoration("Enter address"),
              ),
              const SizedBox(height: 12),
              _buildLabel("Date of Joining"),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _dateOfJoining == null
                        ? "Select date"
                        : "${_dateOfJoining!.day}/${_dateOfJoining!.month}/${_dateOfJoining!.year}",
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 120),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: const BorderSide(color: Colors.black12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D2926),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
