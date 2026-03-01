import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/provider/add_shop_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';

import 'custom_text_field.dart';
import 'form_actions.dart';
import 'phone_form_field.dart';

class AddShopForm extends StatelessWidget {
  const AddShopForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddShopProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: provider.formKey,
          onChanged: () {
            provider.setCanSubmit(
              provider.formKey.currentState?.validate() ?? false,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: provider.nameController,
                hint: 'Enter shop name',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Shop name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: provider.managerController,
                hint: 'Enter contact person name',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Contact person is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              PhoneFormField(
                controller: provider.phoneController,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: provider.cityController,
                hint: 'Enter city',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'City is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: provider.addressController,
                hint: 'Enter Location',
                maxLines: 4,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              FormActions(
                isLoading: provider.isLoading,
                canSubmit: provider.canSubmit,
                onCancel: () => Navigator.pop(context),
                onSubmit: (localContext) async {
                  final success = await provider.submit(localContext);
                  if (provider.lastError != null) {
                    if (!localContext.mounted) return false;
                    ScaffoldMessenger.of(localContext).showSnackBar(
                      SnackBar(content: Text(provider.lastError!)),
                    );
                    return false;
                  }
                  if (!localContext.mounted) {
                    return false;
                  }
                  if (success) {
                    showDialog(
                      context: localContext,
                      barrierDismissible: false,
                      builder: (dialogContext) => const AddSuccessDialog(
                        title: 'Success',
                        message: 'Operation completed successfully',
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 3));
                    if (!localContext.mounted) return false;
                    Navigator.pop(localContext);
                    Navigator.pop(localContext);
                    return true;
                  }
                  return false;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
