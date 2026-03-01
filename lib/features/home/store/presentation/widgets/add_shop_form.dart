import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/provider/add_shop_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/presentation/widgets/add_success_message.dart';

class AddShopForm extends StatelessWidget {
  const AddShopForm({super.key});

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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

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
              TextFormField(
                controller: provider.nameController,
                decoration: _inputDecoration('Enter shop name'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Shop name is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: provider.managerController,
                decoration: _inputDecoration('Enter contact person name'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Contact person is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: provider.phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('10-digit mobile number').copyWith(
                  prefixText: '91 ',
                  prefixStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Mobile number is required';
                  final cleanPhone = v.trim();
                  if (cleanPhone.length != 10)
                    return 'Enter a valid 10-digit number';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: provider.cityController,
                decoration: _inputDecoration('Enter city'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'City is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: provider.addressController,
                maxLines: 4,
                decoration: _inputDecoration('Enter Location'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Address is required';
                  return null;
                },
              ),
              const SizedBox(height: 24),

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
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (provider.isLoading || !provider.canSubmit)
                          ? null
                          : () async {
                              // capture context to avoid use_build_context_synchronously
                              final localContext = context;
                              final success = await provider.submit(
                                localContext,
                              );
                              if (provider.lastError != null) {
                                if (!localContext.mounted) return;
                                ScaffoldMessenger.of(localContext).showSnackBar(
                                  SnackBar(content: Text(provider.lastError!)),
                                );
                                return;
                              }
                              if (!localContext.mounted) return;
                              if (success) {
                                showDialog(
                                  context: localContext,
                                  barrierDismissible: false,
                                  builder: (dialogContext) =>
                                      const AddSuccessDialog(
                                        title: 'Success',
                                        message:
                                            'Operation completed successfully',
                                      ),
                                );
                                await Future.delayed(
                                  const Duration(seconds: 3),
                                );
                                if (!localContext.mounted) return;
                                Navigator.pop(localContext);
                                Navigator.pop(localContext);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D2926),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Submit',
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
}
