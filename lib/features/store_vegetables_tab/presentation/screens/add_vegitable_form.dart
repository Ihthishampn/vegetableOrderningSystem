import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../widgets/defauly_unit_selector.dart';
import '../widgets/form_action.dart';
import '../widgets/add_veg_form_header.dart';
import '../widgets/image_pick_area.dart';
import '../widgets/label_and_field.dart';
import '../widgets/add_success_message.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';

class AddVegetableForm extends StatefulWidget {
  const AddVegetableForm({super.key});

  @override
  State<AddVegetableForm> createState() => _AddVegetableFormState();
}

class _AddVegetableFormState extends State<AddVegetableForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sortNumberController = TextEditingController();
  String? _selectedImageUrl;
  String _selectedUnit = 'Kg';
  String? _imageError;
  // no longer tracking unit errors; default is Kg and selection is optional
  bool _canSubmit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _sortNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateCanSubmit);
    _sortNumberController.addListener(_updateCanSubmit);
  }

  void _updateCanSubmit() {
    final hasName = _nameController.text.trim().length >= 2;
    final sortText = _sortNumberController.text.trim();
    final sortValid =
        int.tryParse(sortText) != null && (int.parse(sortText) > 0);
    // unit is always non-empty (default kg), so no validation needed
    // image is no longer required
    final newCan = hasName && sortValid;
    if (newCan != _canSubmit) setState(() => _canSubmit = newCan);
  }

  Future<void> _submitForm() async {
    // Clear image error (image is optional)
    setState(() => _imageError = null);

    // Run all TextFormField validators.
    final formValid = _formKey.currentState!.validate();

    // Stop if form validation failed.
    if (!formValid) {
      _updateCanSubmit();
      return;
    }

    final productProvider = context.read<ProductProvider>();
    final authProvider = context.read<AuthProvider>();
    final storeId = authProvider.uid;

    if (storeId == null || storeId.isEmpty) {
      setState(() => _imageError = 'Store ID not found');
      return;
    }

    final success = await productProvider.addProduct(
      name: _nameController.text.trim(),
      category: _selectedUnit,
      price: 0.0,
      stock: 0,
      minStock: 0,
      description: _sortNumberController.text.trim(),
      imageUrl: _selectedImageUrl,
    );

    if (mounted) {
      if (success) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const AddSuccessDialog(
            message: "The vegetable has been successfully added.",
            title: "Added New Vegetable",
          ),
          transitionBuilder: (_, anim, __, child) => ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
            child: child,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
        });
      } else {
        setState(() => _imageError = productProvider.error ?? 'Unknown error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormHeader(),
              const SizedBox(height: 20),

              // Image picker
              ImagePickerBox(
                onImageSelected: (imageUrl) {
                  setState(() {
                    _selectedImageUrl = imageUrl;
                    _imageError = null;
                  });
                },
              ),
              // Image validation error
              if (_imageError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _imageError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 20),

              // Sort Number — digits only, must be a positive integer
              LabelAndField(
                label: "Sort Number *",
                hint: "Enter sort number",
                controller: _sortNumberController,
                inputType: TextInputType.number,
                isRequired: true,

                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Sort number is required';
                  }
                  final n = int.tryParse(v.trim());
                  if (n == null || n <= 0) {
                    return 'Sort number must be a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Vegetable Name — required, min 2 chars
              LabelAndField(
                label: "Vegetable Name *",
                hint: "e.g., Tomato",
                controller: _nameController,
                isRequired: true,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Vegetable name is required';
                  }
                  if (v.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              DefaultUnitSelector(
                onUnitSelected: (unit) => setState(() {
                  _selectedUnit = unit;
                  _updateCanSubmit();
                }),
              ),
              const SizedBox(height: 30),

              FormActionsWithCallback(
                onSubmit: _submitForm,
                enabled: _canSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
