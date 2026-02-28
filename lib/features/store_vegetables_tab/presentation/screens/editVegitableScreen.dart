import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/provider/product_provider.dart';
import '../widgets/image_pick_area.dart';
import '../widgets/label_and_field.dart';
import '../widgets/defauly_unit_selector.dart';
import '../widgets/form_action.dart';
import '../widgets/add_success_message.dart';

class EditVegetablePage extends StatefulWidget {
  final Product? product;
  const EditVegetablePage({super.key, this.product});

  @override
  State<EditVegetablePage> createState() => _EditVegetablePageState();
}

class _EditVegetablePageState extends State<EditVegetablePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _sortNumberController;
  String? _selectedImageUrl;
  String _selectedUnit = 'Kg';
  String? _imageError;
  bool _canSubmit = false;

  void _updateCanSubmit() {
    final hasName = _nameController.text.trim().length >= 2;
    final sortText = _sortNumberController.text.trim();
    final sortValid = int.tryParse(sortText) != null && (int.parse(sortText) > 0);
    final hasImage = _selectedImageUrl != null && _selectedImageUrl!.isNotEmpty;
    final hasUnit = _selectedUnit.isNotEmpty;

    final newCan = hasName && sortValid && hasImage && hasUnit;
    if (newCan != _canSubmit) setState(() => _canSubmit = newCan);
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _sortNumberController = TextEditingController(text: '');
    _selectedUnit = (widget.product?.unit.isNotEmpty == true)
        ? widget.product!.unit
        : 'Kg';
    _selectedImageUrl = widget.product?.imageUrl;
    _nameController.addListener(_updateCanSubmit);
    _sortNumberController.addListener(_updateCanSubmit);
    _updateCanSubmit();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sortNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    // Validate image separately (not a TextFormField).
    if (_selectedImageUrl == null || _selectedImageUrl!.isEmpty) {
      setState(() => _imageError = 'Please select an image');
    } else {
      setState(() => _imageError = null);
    }

    // Run all TextFormField validators.
    final formValid = _formKey.currentState!.validate();

    // Stop if either failed.
    if (!formValid || _selectedImageUrl == null || _selectedImageUrl!.isEmpty) {
      return;
    }

    if (widget.product == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product not found')));
      return;
    }

    final productProvider = context.read<ProductProvider>();

    final success = await productProvider.updateProduct(
      productId: widget.product!.id,
      name: _nameController.text.trim(),
      unit: _selectedUnit,
      imageUrl: _selectedImageUrl,
      isAvailable: widget.product!.isAvailable,
      refresh: true,
    );

    if (!mounted) return;

    if (success) {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const AddSuccessDialog(
          message: "The vegetable has been successfully updated.",
          title: "Vegetable Updated",
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
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Edit Vegetable",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),

              // Image picker
              ImagePickerBox(
                initialImageUrl: _selectedImageUrl,
                onImageSelected: (url) {
                  setState(() {
                    _selectedImageUrl = url;
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

              // Sort Number — must be a positive integer
              LabelAndField(
                label: "Sort Number *",
                hint: "Enter sort number",
                controller: _sortNumberController,
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

              // Vegetable Name — required, letters/spaces only
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
                initialUnit: _selectedUnit,
                onUnitSelected: (unit) => setState(() {
                  _selectedUnit = unit;
                  _updateCanSubmit();
                }),
              ),
              const SizedBox(height: 30),

              FormActionsWithCallback(onSubmit: _submitForm, enabled: _canSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
