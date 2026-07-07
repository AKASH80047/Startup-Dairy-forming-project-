import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../location/presentation/bloc/location_cubit.dart';
import '../../../location/presentation/bloc/location_state.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/checkout_cubit.dart';
import '../bloc/checkout_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _utrController = TextEditingController();

  String _selectedSlot = 'morning'; // 'morning' or 'evening'
  String _selectedPayment = 'cod'; // 'cod' or 'credit' or 'upi'

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _utrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.checkoutTitle),
        elevation: 0,
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            // 1. Clear shopping cart
            context.read<CartCubit>().clearCart();
            // 2. Redirect to success screen
            context.go('/order-success', extra: state.order);
          } else if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          final cartState = context.watch<CartCubit>().state;
          final locationState = context.watch<LocationCubit>().state;

          if (locationState is! LocationSuccess) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off_rounded, size: 64, color: AppConstants.accentOrange),
                    const SizedBox(height: 16),
                    Text(
                      isHindi ? 'लोकेशन सेट नहीं है' : 'Location Not Set',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isHindi
                          ? 'ऑर्डर सबमिट करने के लिए कृपया पहले कार्ट में जाकर डिलीवरी लोकेशन चुनें।'
                          : 'Please specify your delivery address and location details on the Cart page before checking out.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: Text(isHindi ? 'कार्ट पर वापस जाएं' : 'Return to Cart'),
                    ),
                  ],
                ),
              ),
            );
          }

          final address = locationState.address!;

          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Address review box
                    _buildSectionHeader(isHindi ? 'वितरण का पता' : 'Delivery Address'),
                    _buildAddressCard(address, isHindi),
                    const SizedBox(height: 20),

                    // Customer info Form
                    _buildSectionHeader(isHindi ? 'संपर्क जानकारी' : 'Contact Information'),
                    _buildContactCard(l10n),
                    const SizedBox(height: 20),

                    // Delivery scheduling slot selection
                    _buildSectionHeader(l10n.deliverySlotLabel),
                    _buildSlotSelector(l10n),
                    const SizedBox(height: 20),

                    // Payment mode selector
                    _buildSectionHeader(l10n.paymentMethodLabel),
                    _buildPaymentSelector(l10n, isHindi),
                    const SizedBox(height: 20),

                    if (_selectedPayment == 'upi') ...[
                      _buildUpiPaymentSection(cartState.cart.grandTotal, isHindi),
                      const SizedBox(height: 20),
                    ],

                    // Bill Summary
                    _buildSectionHeader(isHindi ? 'बिल का विवरण' : 'Bill Summary'),
                    _buildBillDetailsCard(cartState.cart, isHindi, l10n),
                    const SizedBox(height: 32),

                    // Submit CTA Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is CheckoutLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final order = OrderEntity(
                                    id: 'PDF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                                    customerName: _nameController.text.trim(),
                                    customerPhone: _phoneController.text.trim(),
                                    address: address,
                                    deliverySlot: _selectedSlot,
                                    paymentMethod: _selectedPayment,
                                    items: cartState.cart.items,
                                    subtotal: cartState.cart.subtotal,
                                    deliveryCharge: cartState.cart.deliveryCharge,
                                    grandTotal: cartState.cart.grandTotal,
                                    createdAt: DateTime.now(),
                                  );
                                  if (_selectedPayment == 'upi') {
                                    context.push('/mock-gateway', extra: order);
                                  } else {
                                    context.read<CheckoutCubit>().placeOrder(order);
                                  }
                                }
                              },
                        child: Text(l10n.placeOrderLabel),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              if (state is CheckoutLoading)
                Container(
                  color: Colors.black38,
                  child: Center(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: AppConstants.surfaceWhite,
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(color: AppConstants.primaryGreen),
                            const SizedBox(height: 20),
                            Text(
                              isHindi ? 'ऑर्डर सुरक्षित किया जा रहा है...' : 'Securing your order...',
                              style: const TextStyle(
                                color: AppConstants.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppConstants.primaryGreen.withOpacity(0.8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAddressCard(dynamic address, bool isHindi) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on_rounded, color: AppConstants.accentGold, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.addressLine,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isHindi ? "गांव/कस्बा" : "Village"}: ${address.village} • Pincode: ${address.pincode}',
                    style: const TextStyle(color: AppConstants.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Name Field
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return l10n.nameEmptyError;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                labelText: l10n.fullNameLabel,
                filled: true,
                fillColor: AppConstants.backgroundCream,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (val) {
                if (val == null || val.trim().length != 10 || int.tryParse(val.trim()) == null) {
                  return l10n.phoneInvalidError;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_android_rounded, size: 20),
                labelText: l10n.phoneNumberLabel,
                filled: true,
                fillColor: AppConstants.backgroundCream,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotSelector(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildSelectorOption(
            title: l10n.morningSlotLabel.split(' ')[0],
            subtitle: l10n.morningSlotLabel.substring(l10n.morningSlotLabel.indexOf('(')),
            icon: Icons.wb_sunny_outlined,
            isSelected: _selectedSlot == 'morning',
            onTap: () => setState(() => _selectedSlot = 'morning'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSelectorOption(
            title: l10n.eveningSlotLabel.split(' ')[0],
            subtitle: l10n.eveningSlotLabel.substring(l10n.eveningSlotLabel.indexOf('(')),
            icon: Icons.nights_stay_outlined,
            isSelected: _selectedSlot == 'evening',
            onTap: () => setState(() => _selectedSlot = 'evening'),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSelector(AppLocalizations l10n, bool isHindi) {
    return Row(
      children: [
        Expanded(
          child: _buildSelectorOption(
            title: isHindi ? 'नकद' : 'Cash (COD)',
            subtitle: isHindi ? 'घर पर भुगतान' : 'Pay at door',
            icon: Icons.payments_outlined,
            isSelected: _selectedPayment == 'cod',
            onTap: () => setState(() => _selectedPayment = 'cod'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSelectorOption(
            title: isHindi ? 'लोकल क्रेडिट' : 'Credit (खाता)',
            subtitle: isHindi ? 'खाते में जोड़ें' : 'Log on Khata',
            icon: Icons.menu_book_outlined,
            isSelected: _selectedPayment == 'credit',
            onTap: () => setState(() => _selectedPayment = 'credit'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSelectorOption(
            title: isHindi ? 'यूपीआई/क्यूआर' : 'UPI / QR',
            subtitle: isHindi ? 'ऑनलाइन ट्रांसफर' : 'Pay online',
            icon: Icons.qr_code_rounded,
            isSelected: _selectedPayment == 'upi',
            onTap: () => setState(() => _selectedPayment = 'upi'),
          ),
        ),
      ],
    );
  }

  Widget _buildUpiPaymentSection(double payableAmount, bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.dividerColor, width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            isHindi ? 'अग्रिम भुगतान क्यूआर स्कैन करें' : 'Scan QR to Pay',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.primaryGreen),
          ),
          const SizedBox(height: 12),
          Image.network(
            'https://business.paytm.com/s3assets/images/allinoneqr/retina/bnr-pwe1919@2x.webp?version=1782836885',
            width: 220,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
          const SizedBox(height: 12),
          Image.network(
            'https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=upi://pay?pa=pandeydairy@ybl%26pn=Pandey%26am=$payableAmount',
            width: 140,
            height: 140,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code_2_rounded, size: 80),
          ),
          const SizedBox(height: 8),
          const Text(
            'UPI ID: pandeydairy@ybl',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppConstants.textSecondary),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _utrController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: isHindi ? '१२-अंकों का यूपीआई / UTR ट्रांजैक्शन आईडी' : 'Enter 12-Digit Transaction / UTR ID',
              prefixIcon: const Icon(Icons.numbers_rounded),
            ),
            validator: (value) {
              if (value == null || value.length != 12) {
                return isHindi ? 'कृपया १२ अंकों की मान्य आईडी दर्ज करें' : 'Please enter a valid 12-digit UTR ID';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryGreen.withOpacity(0.08) : AppConstants.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppConstants.primaryGreen : AppConstants.dividerColor,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppConstants.primaryGreen : AppConstants.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? AppConstants.primaryGreen : AppConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 9, color: AppConstants.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetailsCard(dynamic cart, bool isHindi, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // List of items summarized
            ...cart.items.map<Widget>((item) {
              final String name = isHindi ? item.nameHindi : item.nameEnglish;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$name (${item.unit} x ${item.quantity})',
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₹${item.subtotal.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
            const Divider(color: AppConstants.dividerColor),
            const SizedBox(height: 8),
            
            // Subtotal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isHindi ? 'कुल योग' : 'Subtotal', style: const TextStyle(fontSize: 12)),
                Text('₹${cart.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),

            // Delivery Fee Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isHindi ? 'डिलीवरी शुल्क' : 'Delivery Charge', style: const TextStyle(fontSize: 12)),
                Text(
                  cart.deliveryCharge == 0.0 ? (isHindi ? 'मुफ़्त' : 'FREE') : '₹${cart.deliveryCharge.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: cart.deliveryCharge == 0.0 ? FontWeight.bold : FontWeight.normal,
                    color: cart.deliveryCharge == 0.0 ? AppConstants.primaryGreen : AppConstants.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppConstants.dividerColor),
            const SizedBox(height: 8),

            // Grand Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.totalAmountLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryGreen, fontSize: 14),
                ),
                Text(
                  '₹${cart.grandTotal.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: AppConstants.primaryGreen, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
