import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../../domain/entities/payment_enums.dart';

class PaymentMethodPage extends StatefulWidget {
  final OrderEntity order;

  const PaymentMethodPage({super.key, required this.order});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  PaymentMethod _selectedMethod = PaymentMethod.cod;
  final TextEditingController _utrController = TextEditingController();
  final _qrFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.order.paymentMethod == 'upi') {
      _selectedMethod = PaymentMethod.upi;
    } else if (widget.order.paymentMethod == 'online') {
      _selectedMethod = PaymentMethod.online;
    } else if (widget.order.paymentMethod == 'qr' || widget.order.paymentMethod == 'qrManual') {
      _selectedMethod = PaymentMethod.qrManual;
    } else {
      _selectedMethod = PaymentMethod.cod;
    }
  }

  @override
  void dispose() {
    _utrController.dispose();
    super.dispose();
  }

  void _onProceed(BuildContext context) {
    if (_selectedMethod == PaymentMethod.qrManual) {
      if (!_qrFormKey.currentState!.validate()) return;
      context.push('/payment-processing', extra: {
        'order': widget.order,
        'method': 'qrManual',
        'utr': _utrController.text.trim(),
      });
    } else if (_selectedMethod == PaymentMethod.cod) {
      context.push('/payment-processing', extra: {
        'order': widget.order,
        'method': 'cod',
      });
    } else if (_selectedMethod == PaymentMethod.upi || _selectedMethod == PaymentMethod.online) {
      context.read<PaymentBloc>().add(CreatePaymentRequested(
            cartId: 'cart_current',
            addressId: 'address_current',
            paymentMethod: _selectedMethod.name,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentCheckoutReady) {
          context.push('/payment-processing', extra: {
            'order': widget.order,
            'method': _selectedMethod.name,
            'session': state.session,
          });
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.redAccent),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppConstants.backgroundCream,
        appBar: AppBar(
          title: Text(l10n.choosePaymentMethod),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isHindi ? 'कुल देय राशि:' : 'Amount Payable:',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '₹${widget.order.grandTotal.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  l10n.choosePaymentMethod,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                RadioGroup<PaymentMethod>(
                  groupValue: _selectedMethod,
                  onChanged: (PaymentMethod? value) {
                    if (value != null) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      _buildMethodTile(
                        method: PaymentMethod.cod,
                        title: l10n.cashOnDelivery,
                        icon: Icons.money_rounded,
                        subtitle: isHindi ? 'वितरण के समय नकद भुगतान करें' : 'Pay with cash at your doorstep',
                      ),
                      _buildMethodTile(
                        method: PaymentMethod.online,
                        title: l10n.onlinePayment,
                        icon: Icons.credit_card_rounded,
                        subtitle: isHindi ? 'डेबिट/क्रेडिट कार्ड, नेट बैंकिंग' : 'Cards, Netbanking, Wallets',
                      ),
                      _buildMethodTile(
                        method: PaymentMethod.upi,
                        title: l10n.upi,
                        icon: Icons.account_balance_wallet_rounded,
                        subtitle: isHindi ? 'गूगल पे, फ़ोन पे, पेटीएम' : 'Google Pay, PhonePe, Paytm',
                      ),
                      _buildMethodTile(
                        method: PaymentMethod.qrManual,
                        title: l10n.payViaBusinessQR,
                        icon: Icons.qr_code_scanner_rounded,
                        subtitle: isHindi ? 'दुकान के क्यूआर कोड को स्कैन करें' : 'Scan business QR code directly',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (_selectedMethod == PaymentMethod.qrManual) ...[
                  Form(
                    key: _qrFormKey,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                      ),
                      color: AppConstants.surfaceWhite,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.qr_code_2_rounded, size: 120, color: AppConstants.textPrimary),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isHindi ? '1. QR कोड स्कैन करके भुगतान करें' : '1. Scan QR and pay exact amount',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isHindi ? '2. UTR/ट्रांजैक्शन आईडी नीचे दर्ज करें' : '2. Enter Transaction UTR ID below',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _utrController,
                              decoration: InputDecoration(
                                labelText: l10n.utrLabel,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.pin_rounded),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 8) {
                                  return isHindi ? 'कृपया वैध UTR संख्या दर्ज करें' : 'Please enter a valid UTR ID';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    final bool isLoading = state is PaymentCreating || state is PaymentProcessing;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _onProceed(context),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(isHindi ? 'भुगतान के लिए आगे बढ़ें' : 'Proceed to Payment'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodTile({
    required PaymentMethod method,
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    final bool isSelected = _selectedMethod == method;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? AppConstants.primaryGreen : AppConstants.dividerColor,
          width: isSelected ? 2.0 : 0.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = method;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppConstants.primaryGreen : AppConstants.textSecondary,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected ? AppConstants.primaryGreen : AppConstants.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<PaymentMethod>(
                value: method,
                groupValue: _selectedMethod,
                onChanged: (PaymentMethod? value) {
                  if (value != null) {
                    setState(() {
                      _selectedMethod = value;
                    });
                  }
                },
                activeColor: AppConstants.primaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
