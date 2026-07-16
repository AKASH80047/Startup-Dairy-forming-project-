import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../location/presentation/bloc/location_cubit.dart';
import '../../../location/presentation/bloc/location_state.dart';
import '../../domain/entities/fodder_item_entity.dart';
import '../bloc/fodder_cubit.dart';
import '../bloc/fodder_state.dart';

class UploadFodderPage extends StatefulWidget {
  const UploadFodderPage({super.key});

  @override
  State<UploadFodderPage> createState() => _UploadFodderPageState();
}

class _UploadFodderPageState extends State<UploadFodderPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleEnController = TextEditingController();
  final _titleHiController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sellerNameController = TextEditingController();
  final _sellerPhoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();

  String _selectedCategory = 'Bhusa';
  String _selectedUnit = 'Quintal';
  bool _deliveryAvailable = true;

  final List<String> _categories = [
    'Bhusa',
    'Dry Grass',
    'Green Grass',
    'Silage',
    'Napier',
    'Berseem',
    'Maize Fodder',
    'Animal Feed',
    'Mineral Mixture'
  ];

  final List<String> _units = ['Quintal', 'Kg', 'Bundle', 'Trolley'];

  @override
  void initState() {
    super.initState();
    // Pre-populate location if available
    final locationCubitState = context.read<LocationCubit>().state;
    if (locationCubitState is LocationSuccess && locationCubitState.address != null) {
      final addr = locationCubitState.address!;
      _villageController.text = addr.village;
      _districtController.text = 'Jaipur'; // Default mock district
      _stateController.text = 'Rajasthan'; // Default mock state
    }
  }

  @override
  void dispose() {
    _titleEnController.dispose();
    _titleHiController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final fodder = FodderItemEntity(
        id: 'fodder_user_${DateTime.now().millisecondsSinceEpoch}',
        titleEn: _titleEnController.text.trim(),
        titleHi: _titleHiController.text.trim(),
        categoryEn: _selectedCategory,
        categoryHi: _selectedCategory == 'Bhusa' ? 'भूसा' : 'चारा',
        imageUrl: 'assets/images/cat_fodder.jpg', // Standard high-quality placeholder asset
        price: double.parse(_priceController.text),
        unitEn: _selectedUnit,
        unitHi: _selectedUnit == 'Quintal' ? 'क्विंटल' : 'इकाई',
        quantity: double.parse(_quantityController.text),
        sellerName: _sellerNameController.text.trim(),
        sellerPhone: _sellerPhoneController.text.trim(),
        village: _villageController.text.trim(),
        district: _districtController.text.trim(),
        state: _stateController.text.trim(),
        deliveryAvailable: _deliveryAvailable,
        createdAt: DateTime.now(),
      );

      context.read<FodderCubit>().uploadFodder(fodder);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'चारा बेचें' : 'Sell Fodder'),
        elevation: 0,
      ),
      body: BlocListener<FodderCubit, FodderState>(
        listener: (context, state) {
          if (state is FodderUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isHindi ? 'लिस्टिंग सफलतापूर्वक जोड़ी गई!' : 'Fodder listing uploaded successfully!',
                ),
                backgroundColor: AppConstants.primaryGreen,
              ),
            );
            context.pop();
          } else if (state is FodderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Eng Title
                _buildTextField(
                  controller: _titleEnController,
                  label: 'Listing Title (English)',
                  validator: (val) => val == null || val.isEmpty ? 'Enter title in English' : null,
                ),
                const SizedBox(height: 16),

                // Hindi Title
                _buildTextField(
                  controller: _titleHiController,
                  label: 'लिस्टिंग शीर्षक (हिंदी)',
                  validator: (val) => val == null || val.isEmpty ? 'हिंदी में शीर्षक डालें' : null,
                ),
                const SizedBox(height: 16),

                // Category & Unit Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHindi ? 'श्रेणी' : 'Category',
                            style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppConstants.surfaceWhite,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: _categories.map((cat) {
                              return DropdownMenuItem(value: cat, child: Text(cat));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHindi ? 'मात्रा इकाई' : 'Unit',
                            style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedUnit,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppConstants.surfaceWhite,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: _units.map((unit) {
                              return DropdownMenuItem(value: unit, child: Text(unit));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedUnit = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Price and Qty Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _priceController,
                        label: isHindi ? 'दर (₹ प्रति इकाई)' : 'Rate (₹ per Unit)',
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.isEmpty ? 'Enter rate' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _quantityController,
                        label: isHindi ? 'मात्रा' : 'Quantity',
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.isEmpty ? 'Enter quantity' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Seller Name
                _buildTextField(
                  controller: _sellerNameController,
                  label: isHindi ? 'विक्रेता का नाम' : 'Seller Name',
                  validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 16),

                // Seller Phone
                _buildTextField(
                  controller: _sellerPhoneController,
                  label: isHindi ? 'मोबाइल नंबर' : 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (val) => val == null || val.length != 10 ? 'Enter valid 10-digit number' : null,
                ),
                const SizedBox(height: 16),

                // Location Specs
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _villageController,
                        label: isHindi ? 'गांव' : 'Village',
                        validator: (val) => val == null || val.isEmpty ? 'Enter village' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _districtController,
                        label: isHindi ? 'जिला' : 'District',
                        validator: (val) => val == null || val.isEmpty ? 'Enter district' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _stateController,
                  label: isHindi ? 'राज्य' : 'State',
                  validator: (val) => val == null || val.isEmpty ? 'Enter state' : null,
                ),
                const SizedBox(height: 16),

                // Delivery Toggle Switch
                SwitchListTile(
                  value: _deliveryAvailable,
                  onChanged: (val) => setState(() => _deliveryAvailable = val),
                  title: Text(
                    isHindi ? 'होम डिलीवरी उपलब्ध है?' : 'Delivery available?',
                    style: TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  activeColor: AppConstants.primaryGreen,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isHindi ? 'लिस्टिंग जमा करें' : 'Submit Listing',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppConstants.surfaceWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConstants.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConstants.primaryGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
