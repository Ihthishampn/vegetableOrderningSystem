import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../store_vegetables_tab/presentation/widgets/add_success_message.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/store_shops/presentation/provider/shop_provider.dart';
import 'package:vegetable_ordering_system/features/store_shops/domain/entities/shop.dart';

class ShopsManagmentScreen extends StatefulWidget {
  const ShopsManagmentScreen({super.key});

  @override
  State<ShopsManagmentScreen> createState() => _ShopsManagmentScreenState();
}

class _ShopsManagmentScreenState extends State<ShopsManagmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final shopProv = Provider.of<ShopProvider>(context, listen: false);
      if (auth.uid != null) {
        shopProv.initialize(auth.uid!);
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
          "Shops",
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
          // 1. Scrollable Shop List
          Consumer<ShopProvider>(
            builder: (context, shopProv, _) {
              if (shopProv.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (shopProv.error != null) {
                return Center(child: Text('Error: ${shopProv.error}'));
              }
              final shops = shopProv.shopList;
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                itemCount: shops.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildShopCard(shops[index]);
                },
              );
            },
          ),

          // 2. Fixed "Add New Shop" Button
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
                      builder: (context) => const AddShopPage(),
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
                  "+ Add New Shop",
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

  Widget _buildShopCard(Shop shop) {
    bool active = shop.isActive;

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
            shop.shopName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          _buildInfoRow("Contact Person", shop.managerName ?? ""),
          _buildInfoRow("Mobile Number", shop.phone),
          _buildInfoRow("Location", shop.address),
          _buildInfoRow(
            "Added Date",
            "${shop.createdAt.day}/${shop.createdAt.month}/${shop.createdAt.year}",
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Edit Button (Adjusted height to match toggle)
              SizedBox(
                height: 32, // Controlled height
                child: OutlinedButton.icon(
                  onPressed: () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddShopPage(shop: shop),
                        ),
                      );
                    }
                    ;
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

              // Slim Status Toggle Container
              Container(
                height: 32, // Matches Edit button height
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 2,
                ), // Tighter padding
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
                        fontSize: 12, // Slightly smaller font
                      ),
                    ),
                    const SizedBox(width: 2),
                    Transform.scale(
                      scale: 0.65, // Scale down the switch
                      child: Switch(
                        value: active,
                        // This is key: it removes the extra padding around the switch
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (val) async {
                          final provider = Provider.of<ShopProvider>(
                            context,
                            listen: false,
                          );
                          await provider.toggleShopStatus(shop.id, val);
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

class AddShopPage extends StatefulWidget {
  final Shop? shop;
  const AddShopPage({super.key, this.shop});

  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _managerController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _canSubmit = false;

  bool get isEdit => widget.shop != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shop?.shopName ?? '');
    _managerController = TextEditingController(
      text: widget.shop?.managerName ?? '',
    );
    _phoneController = TextEditingController(text: widget.shop?.phone ?? '');
    _addressController = TextEditingController(
      text: widget.shop?.address ?? '',
    );
    _cityController = TextEditingController(text: widget.shop?.city ?? '');
    // For edit mode, initialize _canSubmit based on prefilled fields
    _canSubmit =
        widget.shop != null &&
        _nameController.text.trim().isNotEmpty &&
        _managerController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty &&
        _addressController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _managerController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
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

  Future<void> _submit() async {
    final provider = Provider.of<ShopProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.uid == null) return;
    // Use form validation to ensure all fields are provided
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final now = DateTime.now();
    final shop = Shop(
      id: widget.shop?.id ?? '',
      storeId: auth.uid!,
      shopName: _nameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      phone: _phoneController.text.trim(),
      managerName: _managerController.text.trim(),
      createdAt: widget.shop?.createdAt ?? now,
      updatedAt: now,
      isActive: widget.shop?.isActive ?? true,
    );
    setState(() => _isLoading = true);
    final success = isEdit
        ? await provider.updateShop(shop)
        : await provider.addShop(shop);
    setState(() => _isLoading = false);
    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddSuccessDialog(
          title: isEdit ? "Shop Updated" : "Added New Shop",
          message: isEdit
              ? "The shop details have been successfully updated."
              : "The shop has been successfully added.",
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.pop(context); // close dialog
          Navigator.pop(context); // close page
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
          isEdit ? "Edit Shop Details" : "Add New Shop",
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
              Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    _canSubmit = _formKey.currentState?.validate() ?? false;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Store Name *"),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration("Enter shop name"),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Shop name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildLabel("Contact Person Name *"),
                    TextFormField(
                      controller: _managerController,
                      decoration: _inputDecoration("Enter contact person name"),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Contact person is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildLabel("Mobile Number *"),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        "Enter 10-digit mobile number",
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Mobile number is required';
                        if (v.trim().length < 7)
                          return 'Enter a valid mobile number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildLabel("City *"),
                    TextFormField(
                      controller: _cityController,
                      decoration: _inputDecoration("Enter city"),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'City is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildLabel("Location / Address *"),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 4,
                      decoration: _inputDecoration("Enter Location"),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Address is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _buildLabel("Contact Person Name *"),
              TextField(
                controller: _managerController,
                decoration: _inputDecoration("Enter contact person name"),
              ),
              const SizedBox(height: 12),

              _buildLabel("Mobile Number"),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Enter 10-digit mobile number"),
              ),
              const SizedBox(height: 12),

              _buildLabel("Location / Address"),
              TextField(
                controller: _addressController,
                maxLines: 4,
                decoration: _inputDecoration("Enter Location"),
              ),
              const SizedBox(height: 120),

              // Bottom Action Buttons
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
                      onPressed: (_isLoading || !_canSubmit) ? null : _submit,
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

  // Removed _buildTextField - not used, using TextFormField with validators instead
}
