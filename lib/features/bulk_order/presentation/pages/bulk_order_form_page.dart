import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/web_image_helper.dart';
import '../../../location/presentation/bloc/location_cubit.dart';
import '../../../location/presentation/bloc/location_state.dart';
import '../../../location/domain/entities/user_address.dart';
import '../bloc/bulk_order_cubit.dart';
import '../bloc/bulk_order_state.dart';
import '../../domain/entities/bulk_order_entity.dart';
import '../../domain/entities/bulk_order_item.dart';

class BulkOrderFormPage extends StatefulWidget {
  const BulkOrderFormPage({super.key});

  @override
  State<BulkOrderFormPage> createState() => _BulkOrderFormPageState();
}

class _BulkOrderFormPageState extends State<BulkOrderFormPage> {
  int _currentStep = 0;

  // Step 1 controllers: Contact & Event details
  final _formKeyStep1 = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guestsController = TextEditingController();
  String _selectedEventType = 'Wedding';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  // Step 2 bulk quantities
  final Map<String, double> _quantities = {
    'prod_cow_milk': 0.0,
    'prod_buffalo_milk': 0.0,
    'prod_paneer': 0.0,
    'prod_curd': 0.0,
    'prod_ghee': 0.0,
    'prod_buttermilk': 0.0,
  };

  final List<Map<String, dynamic>> _bulkProducts = [
    {
      'id': 'prod_buffalo_milk',
      'nameEn': 'Pure Buffalo Milk',
      'nameHi': 'भैंस का दूध',
      'price': 80.0,
      'unit': 'L',
      'icon': Icons.opacity_rounded,
      'step': 5.0, // Minimum increments
    },
    {
      'id': 'prod_cow_milk',
      'nameEn': 'Pure Cow Milk',
      'nameHi': 'गाय का दूध',
      'price': 60.0,
      'unit': 'L',
      'icon': Icons.water_drop_outlined,
      'step': 5.0,
    },
    {
      'id': 'prod_paneer',
      'nameEn': 'Premium Fresh Paneer',
      'nameHi': 'ताज़ा पनीर',
      'price': 440.0,
      'unit': 'kg',
      'icon': Icons.grid_view_rounded,
      'step': 1.0,
    },
    {
      'id': 'prod_curd',
      'nameEn': 'Thick Creamy Curd',
      'nameHi': 'मलाईदार दही',
      'price': 90.0,
      'unit': 'L',
      'icon': Icons.icecream_outlined,
      'step': 2.0,
    },
    {
      'id': 'prod_ghee',
      'nameEn': 'Pure Desi Ghee',
      'nameHi': 'शुद्ध देसी घी',
      'price': 750.0,
      'unit': 'L',
      'icon': Icons.circle_outlined,
      'step': 1.0,
    },
    {
      'id': 'prod_buttermilk',
      'nameEn': 'Refreshing Buttermilk',
      'nameHi': 'ठंडी मसाला छाछ',
      'price': 40.0,
      'unit': 'L',
      'icon': Icons.local_drink_outlined,
      'step': 5.0,
    },
  ];

  // Step 3 controllers: Location
  final _formKeyStep3 = GlobalKey<FormState>();
  final _addressLineController = TextEditingController();
  final _villageController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _notesController = TextEditingController();

  // Step 4 controllers: Payment
  final _advanceController = TextEditingController();
  final _utrController = TextEditingController();
  String _paymentMethod = 'upi'; // 'cod' or 'upi'

  @override
  void initState() {
    super.initState();
    // Fill user details from storage/previous order if available
    final storage = context.read<StorageService>();
    final lastAddress = storage.getCachedAddress();
    if (lastAddress != null) {
      _addressLineController.text = lastAddress.addressLine;
      _villageController.text = lastAddress.village;
      _pincodeController.text = lastAddress.pincode;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _guestsController.dispose();
    _addressLineController.dispose();
    _villageController.dispose();
    _pincodeController.dispose();
    _notesController.dispose();
    _advanceController.dispose();
    _utrController.dispose();
    super.dispose();
  }

  // Calculation helpers
  double get _subtotal {
    double total = 0.0;
    _quantities.forEach((prodId, qty) {
      final product = _bulkProducts.firstWhere((p) => p['id'] == prodId);
      total += qty * (product['price'] as double);
    });
    return total;
  }

  double get _discount => BulkOrderCubit.calculateDiscount(_subtotal);
  double get _discountPercentage => BulkOrderCubit.calculateDiscountPercentage(_subtotal);
  double get _deliveryCharge => _subtotal > 0 ? (_subtotal >= 10000 ? 0.0 : 150.0) : 0.0; // Free delivery for high totals
  double get _grandTotal => _subtotal - _discount + _deliveryCharge;
  double get _minAdvance => BulkOrderCubit.calculateMinAdvance(_grandTotal);

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKeyStep1.currentState!.validate()) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 1) {
      if (_subtotal == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one item with a valid bulk quantity.')),
        );
      } else {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 2) {
      if (_formKeyStep3.currentState!.validate()) {
        // Pre-fill min advance payment on step 4 transition
        _advanceController.text = _minAdvance.toStringAsFixed(0);
        setState(() => _currentStep++);
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitBulkBooking() async {
    final double advance = double.tryParse(_advanceController.text) ?? 0.0;
    if (advance < _minAdvance - 0.01) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode == 'hi'
                ? 'अग्रिम भुगतान न्यूनतम 20% होना चाहिए।'
                : 'Advance payment must be at least 20% of the total amount.',
          ),
        ),
      );
      return;
    }

    if (_paymentMethod == 'upi' && _utrController.text.length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 12-digit UPI Ref/UTR ID.')),
      );
      return;
    }

    final double pending = _grandTotal - advance;

    final locationState = context.read<LocationCubit>().state;
    double lat = LocationCubit.farmLatitude;
    double lon = LocationCubit.farmLongitude;
    if (locationState is LocationSuccess) {
      lat = locationState.latitude;
      lon = locationState.longitude;
    }

    final address = UserAddress(
      latitude: lat,
      longitude: lon,
      addressLine: _addressLineController.text.trim(),
      village: _villageController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    final List<BulkOrderItem> selectedItems = [];
    _quantities.forEach((prodId, qty) {
      if (qty > 0) {
        final product = _bulkProducts.firstWhere((p) => p['id'] == prodId);
        selectedItems.add(BulkOrderItem(
          productId: prodId,
          nameEnglish: product['nameEn'] as String,
          nameHindi: product['nameHi'] as String,
          price: product['price'] as double,
          unit: product['unit'] as String,
          quantity: qty,
        ));
      }
    });

    final String orderId = 'BULK-${DateTime.now().year}-${(1000 + DateTime.now().millisecond)}';

    final bulkOrder = BulkOrderEntity(
      id: orderId,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      eventType: _selectedEventType,
      eventDate: _selectedDate,
      expectedGuests: int.tryParse(_guestsController.text) ?? 50,
      address: address,
      items: selectedItems,
      subtotal: _subtotal,
      discountAmount: _discount,
      deliveryCharge: _deliveryCharge,
      advancePaid: advance,
      pendingBalance: pending,
      grandTotal: _grandTotal,
      notes: _notesController.text.trim() + (_paymentMethod == 'upi' ? ' (UTR: ${_utrController.text})' : ''),
      paymentMethod: _paymentMethod,
      status: 'Confirmed',
      createdAt: DateTime.now(),
    );

    await context.read<BulkOrderCubit>().placeBulkOrder(bulkOrder);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.bulkOrderFormTitle),
        elevation: 0,
      ),
      body: BlocListener<BulkOrderCubit, BulkOrderState>(
        listener: (context, state) {
          if (state is BulkOrderSuccess) {
            context.go('/bulk-order-success', extra: state.order);
          } else if (state is BulkOrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressHeader(isHindi, l10n),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentStepView(isHindi, l10n),
                ),
              ),
              _buildControlButtons(isHindi, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader(bool isHindi, AppLocalizations l10n) {
    final steps = [
      l10n.customerDetailsStep,
      l10n.productsSelectionStep,
      l10n.deliveryDetailsStep,
      l10n.paymentConfirmationStep
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Divider(color: index == 0 ? Colors.transparent : (isCompleted || isCurrent ? AppConstants.primaryGreen : AppConstants.dividerColor), thickness: 2)),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppConstants.primaryGreen
                            : (isCompleted ? AppConstants.primaryGreen.withValues(alpha: 0.1) : Colors.white),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent || isCompleted ? AppConstants.primaryGreen : AppConstants.dividerColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(Icons.check, size: 14, color: AppConstants.primaryGreen)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? Colors.white : AppConstants.textSecondary,
                                ),
                              ),
                      ),
                    ),
                    Expanded(child: Divider(color: index == steps.length - 1 ? Colors.transparent : (isCompleted ? AppConstants.primaryGreen : AppConstants.dividerColor), thickness: 2)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? AppConstants.primaryGreen : AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepView(bool isHindi, AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildStep1EventDetails(isHindi, l10n);
      case 1:
        return _buildStep2ProductsList(isHindi, l10n);
      case 2:
        return _buildStep3Delivery(isHindi, l10n);
      case 3:
        return _buildStep4Payment(isHindi, l10n);
      default:
        return Container();
    }
  }

  Widget _buildStep1EventDetails(bool isHindi, AppLocalizations l10n) {
    final eventTypes = [
      {'val': 'Wedding', 'hi': 'शादी'},
      {'val': 'Birthday', 'hi': 'जन्मदिन'},
      {'val': 'Bhandara', 'hi': 'भंडारा'},
      {'val': 'Religious Function', 'hi': 'धार्मिक कार्यक्रम'},
      {'val': 'Family Function', 'hi': 'पारिवारिक समारोह'},
      {'val': 'School Event', 'hi': 'स्कूल कार्यक्रम'},
      {'val': 'Business Order', 'hi': 'व्यावसायिक ऑर्डर'},
      {'val': 'Catering', 'hi': 'कैटरिंग'},
      {'val': 'Other', 'hi': 'अन्य'},
    ];

    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(isHindi ? 'सम्पर्क एवं समारोह विवरण' : 'Contact & Event Details'),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.fullNameLabel,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return l10n.nameEmptyError;
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: l10n.phoneNumberLabel,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            validator: (value) {
              if (value == null || value.length != 10) return l10n.phoneInvalidError;
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedEventType,
            decoration: InputDecoration(
              labelText: l10n.eventTypeLabel,
              prefixIcon: const Icon(Icons.event_note_rounded),
            ),
            items: eventTypes.map((event) {
              return DropdownMenuItem<String>(
                value: event['val'],
                child: Text(isHindi ? event['hi']! : event['val']!),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedEventType = val);
            },
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.eventDateLabel,
                prefixIcon: const Icon(Icons.calendar_month_outlined),
              ),
              child: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _guestsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: l10n.expectedGuestsLabel,
              prefixIcon: const Icon(Icons.people_alt_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return isHindi ? 'कृपया मेहमानों की संख्या दर्ज करें' : 'Please enter expected guests';
              }
              final int? val = int.tryParse(value);
              if (val == null || val <= 0) {
                return isHindi ? 'मान्य संख्या दर्ज करें' : 'Enter a valid guest count';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2ProductsList(bool isHindi, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(isHindi ? 'थोक सामग्री और मात्रा' : 'Select Product Quantities'),
        const SizedBox(height: 8),
        Text(
          isHindi
              ? '* थोक ऑर्डर के लिए अतिरिक्त छूट देय राशि पर लागू होगी।'
              : '* Special event volume discount automatically applies at checkout step.',
          style: TextStyle(fontSize: 10, color: AppConstants.accentGold, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ..._bulkProducts.map((prod) {
          final String id = prod['id'] as String;
          final String name = isHindi ? prod['nameHi'] as String : prod['nameEn'] as String;
          final double price = prod['price'] as double;
          final String unit = prod['unit'] as String;
          final double step = prod['step'] as double;
          final double qty = _quantities[id] ?? 0.0;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppConstants.primaryGreen.withValues(alpha: 0.08),
                    child: Icon(prod['icon'] as IconData, color: AppConstants.primaryGreen),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('₹$price / $unit', style: TextStyle(color: AppConstants.textSecondary, fontSize: 11)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: AppConstants.textSecondary),
                        onPressed: qty <= 0
                            ? null
                            : () {
                                setState(() {
                                  _quantities[id] = (qty - step).clamp(0.0, 9999.0);
                                });
                              },
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '${qty.toStringAsFixed(0)} $unit',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, color: AppConstants.primaryGreen),
                        onPressed: () {
                          setState(() {
                            _quantities[id] = qty + step;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppConstants.dividerColor, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isHindi ? 'अनुमानित उप-योग:' : 'Estimated Subtotal:', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('₹${_subtotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryGreen, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Delivery(bool isHindi, AppLocalizations l10n) {
    return Form(
      key: _formKeyStep3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(isHindi ? 'डिलीवरी का पता' : 'Delivery Details'),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressLineController,
            decoration: InputDecoration(
              labelText: isHindi ? 'मकान नंबर / गली / क्षेत्र' : 'House No / Street / Landmark Address',
              prefixIcon: const Icon(Icons.home_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return isHindi ? 'कृपया पता दर्ज करें' : 'Please enter delivery address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _villageController,
            decoration: InputDecoration(
              labelText: isHindi ? 'ग्राम / कस्बा' : 'Village / Town',
              prefixIcon: const Icon(Icons.location_city_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return isHindi ? 'कृपया गांव का नाम दर्ज करें' : 'Please enter village name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pincodeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: isHindi ? 'पिनकोड' : 'Pincode',
              prefixIcon: const Icon(Icons.pin_drop_outlined),
            ),
            validator: (value) {
              if (value == null || value.length != 6) {
                return isHindi ? '६ अंकों का पिनकोड दर्ज करें' : 'Please enter a valid 6-digit pincode';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: isHindi ? 'विशेष निर्देश (वैकल्पिक)' : 'Special Instructions / Notes (Optional)',
              prefixIcon: const Icon(Icons.note_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Payment(bool isHindi, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(isHindi ? 'कोटेशन और भुगतान विवरण' : 'Quote & Advance Payment'),
        const SizedBox(height: 16),

        // Cost breakdown card
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInvoiceRow(isHindi ? 'कुल उप-योग:' : 'Items Subtotal:', '₹${_subtotal.toStringAsFixed(0)}'),
                if (_discount > 0) ...[
                  const SizedBox(height: 8),
                  _buildInvoiceRow(
                    '${l10n.bulkDiscountLabel} (${(_discountPercentage * 100).toStringAsFixed(0)}%):',
                    '- ₹${_discount.toStringAsFixed(0)}',
                    textColor: AppConstants.accentGold,
                  ),
                ],
                const SizedBox(height: 8),
                _buildInvoiceRow(isHindi ? 'डिलीवरी शुल्क:' : 'Delivery Charge:', '₹${_deliveryCharge.toStringAsFixed(0)}'),
                Divider(color: AppConstants.dividerColor, height: 24),
                _buildInvoiceRow(
                  isHindi ? 'कुल देय राशि:' : 'Grand Total:',
                  '₹${_grandTotal.toStringAsFixed(0)}',
                  isBold: true,
                  fontSize: 16,
                  textColor: AppConstants.primaryGreen,
                ),
                Divider(color: AppConstants.dividerColor, height: 24),
                _buildInvoiceRow(
                  isHindi ? 'न्यूनतम अग्रिम राशि (20%):' : 'Min Advance Required (20%):',
                  '₹${_minAdvance.toStringAsFixed(0)}',
                  textColor: Colors.blueAccent,
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Input advance payment
        _buildSectionHeader(l10n.paymentConfirmationStep),
        const SizedBox(height: 10),
        Text(
          l10n.minimumAdvanceWarning,
          style: TextStyle(fontSize: 11, color: AppConstants.textSecondary),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _advanceController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.advancePaymentLabel,
            prefixIcon: const Icon(Icons.currency_rupee_rounded),
          ),
          onChanged: (val) {
            setState(() {}); // Force redraw to compute pending balance dynamically
          },
        ),
        const SizedBox(height: 16),

        // Show pending balance card
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.pendingBalanceLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(
              '₹${(_grandTotal - (double.tryParse(_advanceController.text) ?? 0.0)).clamp(0.0, 999999.0).toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Select payment mode
        _buildSectionHeader(isHindi ? 'भुगतान विधि' : 'Advance Payment Mode'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _paymentMethod = 'upi'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _paymentMethod == 'upi' ? AppConstants.primaryGreen.withValues(alpha: 0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _paymentMethod == 'upi' ? AppConstants.primaryGreen : AppConstants.dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.qr_code_rounded, color: AppConstants.primaryGreen),
                      const SizedBox(height: 6),
                      Text(isHindi ? 'यूपीआई / क्यूआर' : 'UPI / QR Scan', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _paymentMethod = 'cod'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _paymentMethod == 'cod' ? AppConstants.primaryGreen.withValues(alpha: 0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _paymentMethod == 'cod' ? AppConstants.primaryGreen : AppConstants.dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.handshake_outlined, color: AppConstants.primaryGreen),
                      const SizedBox(height: 6),
                      Text(isHindi ? 'नकद (कैश)' : 'Cash Payment', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // UPI Scanner Details
        if (_paymentMethod == 'upi') ...[
          Center(
            child: Column(
              children: [
                Text(
                  'Scan QR to Pay Advance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.primaryGreen),
                ),
                const SizedBox(height: 12),
                AppImage(
                  path: 'assets/images/paytm_banner.webp',
                  width: 220,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppConstants.dividerColor, width: 0.5),
                  ),
                  child: AppImage(
                    path: 'https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=upi://pay?pa=pandeydairy@ybl%26pn=Pandey%26am=${double.tryParse(_advanceController.text) ?? _minAdvance}',
                    width: 150,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code_2_rounded, size: 100),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'UPI ID: pandeydairy@ybl',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppConstants.textSecondary),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _utrController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Enter 12-Digit Transaction / UTR ID',
                    prefixIcon: Icon(Icons.numbers_rounded),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInvoiceRow(String label, String value, {bool isBold = false, double fontSize = 13, Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? AppConstants.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold || textColor != null ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? AppConstants.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryGreen,
      ),
    );
  }

  Widget _buildControlButtons(bool isHindi, AppLocalizations l10n) {
    final state = context.watch<BulkOrderCubit>().state;
    final isLoading = state is BulkOrderLoading;

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: isLoading ? null : _prevStep,
                child: Text(isHindi ? 'पीछे' : 'Back'),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : (_currentStep == 3 ? _submitBulkBooking : _nextStep),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      _currentStep == 3
                          ? (isHindi ? 'बुकिंग कन्फर्म करें' : 'Confirm Booking')
                          : (isHindi ? 'आगे बढ़ें' : 'Continue'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
