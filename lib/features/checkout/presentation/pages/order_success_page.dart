import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/order_entity.dart';

class OrderSuccessPage extends StatelessWidget {
  final OrderEntity order;

  const OrderSuccessPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Success checkmark animation box
              Center(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 88,
                    color: AppConstants.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Success headers
              Text(
                l10n.orderSuccessTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.thankYouMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
              ),
              const SizedBox(height: 32),

              // Order Summary details card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Number
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.orderNumberLabel,
                            style: TextStyle(fontSize: 12, color: AppConstants.textSecondary),
                          ),
                          Text(
                            order.id,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.primaryGreen),
                          ),
                        ],
                      ),
                      Divider(height: 24, color: AppConstants.dividerColor),

                      // Delivery Schedule Slot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.estimatedDeliveryLabel,
                            style: TextStyle(fontSize: 12, color: AppConstants.textSecondary),
                          ),
                          Text(
                            order.deliverySlot == 'morning'
                                ? (isHindi ? 'सुबह (6 AM - 9 AM)' : 'Morning (6 AM - 9 AM)')
                                : (isHindi ? 'शाम (5 PM - 8 PM)' : 'Evening (5 PM - 8 PM)'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Payment Method selected
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isHindi ? 'भुगतान विधि' : 'Payment Mode',
                            style: TextStyle(fontSize: 12, color: AppConstants.textSecondary),
                          ),
                          Text(
                            order.paymentMethod == 'cod'
                                ? (isHindi ? 'कैश ऑन डिलीवरी (COD)' : 'Cash on Delivery (COD)')
                                : order.paymentMethod == 'upi'
                                    ? (isHindi ? 'ऑनलाइन यूपीआई (सफल)' : 'Online UPI (Success / Paid)')
                                    : (isHindi ? 'खाता (लोकल क्रेडिट)' : 'Village Credit (Khata)'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Delivery Address info
                      CrossFieldAddressBlock(address: order.address, isHindi: isHindi),
                      Divider(height: 24, color: AppConstants.dividerColor),

                      // List of items ordered
                      Text(
                        l10n.itemsOrderedLabel,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppConstants.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      ...order.items.map((item) {
                        final String name = isHindi ? item.nameHindi : item.nameEnglish;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$name x ${item.quantity}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                '₹${item.subtotal.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                      Divider(height: 24, color: AppConstants.dividerColor),

                      // Totals Summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.totalAmountLabel,
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryGreen, fontSize: 13),
                          ),
                          Text(
                            '₹${order.grandTotal.toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.w900, color: AppConstants.primaryGreen, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  child: Text(l10n.backToHomeLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CrossFieldAddressBlock extends StatelessWidget {
  final dynamic address;
  final bool isHindi;

  const CrossFieldAddressBlock({
    super.key,
    required this.address,
    required this.isHindi,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHindi ? 'डिलिवरी पता:' : 'Deliver to:',
            style: TextStyle(fontSize: 11, color: AppConstants.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            address.addressLine,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            '${isHindi ? "गांव/कस्बा" : "Village"}: ${address.village} • Pincode: ${address.pincode}',
            style: TextStyle(fontSize: 11, color: AppConstants.textSecondary),
          ),
        ],
      ),
    );
  }
}
