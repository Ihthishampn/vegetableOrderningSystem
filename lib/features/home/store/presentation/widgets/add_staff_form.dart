import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/provider/add_staff_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';

import 'custom_text_field.dart';
import 'date_picker_form_field.dart';
import 'form_actions.dart';
import 'phone_form_field.dart';

class AddStaffForm extends StatelessWidget {
  const AddStaffForm({super.key});


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddStaffProvider>(context);

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
                hint: 'Enter staff name',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              PhoneFormField(
                controller: provider.phoneController,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: provider.emailController,
                hint: 'Enter email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: provider.positionController,
                hint: 'Enter position',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Position is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: provider.addressController,
                hint: 'Enter address',
                maxLines: 3,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              DatePickerFormField(
                selectedDate: provider.dateOfJoining,
                onDatePicked: provider.setDate,
                hint: 'Select joining date',
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
                  if (!localContext.mounted) return false;
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
