import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/bulk_order_entity.dart';

class BulkOrderSuccessPage extends StatelessWidget {
  final BulkOrderEntity order;

  const BulkOrderSuccessPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    final String dateString = '${order.eventDate.day}/${order.eventDate.month}/${order.eventDate.year}';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Animated or styled success checkmark
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: AppConstants.primaryGreen,
                ),
              ),
              const SizedBox(height: 24),

              // Success titles
              Text(
                l10n.bulkOrderSuccessTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.bulkOrderSuccessSub,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 32),

              // Booking receipt summary card
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isHindi ? 'ऑर्डर आईडी:' : 'Order ID:',
                            style: TextStyle(fontSize: 12, color: AppConstants.textSecondary),
                          ),
                          Text(
                            order.id,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(color: AppConstants.dividerColor, height: 24),

                      // Event specs
                      _buildSummaryRow(l10n.eventTypeLabel, isHindi ? _translateEventType(order.eventType) : order.eventType),
                      const SizedBox(height: 10),
                      _buildSummaryRow(l10n.eventDateLabel, dateString),
                      const SizedBox(height: 10),
                      _buildSummaryRow(l10n.expectedGuestsLabel, '${order.expectedGuests}'),
                      Divider(color: AppConstants.dividerColor, height: 24),

                      // Items summary list
                      Text(
                        l10n.itemsOrderedLabel,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppConstants.primaryGreen),
                      ),
                      const SizedBox(height: 10),
                      ...order.items.map((item) {
                        final String name = isHindi ? item.nameHindi : item.nameEnglish;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$name (${item.quantity.toStringAsFixed(0)} ${item.unit})',
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
                      Divider(color: AppConstants.dividerColor, height: 24),

                      // Cost breakdowns
                      _buildSummaryRow(isHindi ? 'कुल उप-योग:' : 'Subtotal:', '₹${order.subtotal.toStringAsFixed(0)}'),
                      if (order.discountAmount > 0) ...[
                        const SizedBox(height: 10),
                        _buildSummaryRow(
                          l10n.bulkDiscountLabel,
                          '- ₹${order.discountAmount.toStringAsFixed(0)}',
                          textColor: AppConstants.accentGold,
                        ),
                      ],
                      const SizedBox(height: 10),
                      _buildSummaryRow(isHindi ? 'डिलीवरी शुल्क:' : 'Delivery Charge:', '₹${order.deliveryCharge.toStringAsFixed(0)}'),
                      Divider(color: AppConstants.dividerColor, height: 24),
                      _buildSummaryRow(
                        isHindi ? 'कुल देय राशि:' : 'Grand Total:',
                        '₹${order.grandTotal.toStringAsFixed(0)}',
                        isBold: true,
                        textColor: AppConstants.primaryGreen,
                      ),
                      const SizedBox(height: 10),
                      _buildSummaryRow(
                        l10n.advancePaidLabel,
                        '₹${order.advancePaid.toStringAsFixed(0)}',
                        isBold: true,
                        textColor: Colors.blueAccent,
                      ),
                      const SizedBox(height: 10),
                      _buildSummaryRow(
                        l10n.balanceDueLabel,
                        '₹${order.pendingBalance.toStringAsFixed(0)}',
                        isBold: true,
                        textColor: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Button to close and return
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: Text(l10n.backToHomeLabel),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? AppConstants.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold || textColor != null ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? AppConstants.textPrimary,
          ),
        ),
      ],
    );
  }

  String _translateEventType(String type) {
    switch (type) {
      case 'Wedding':
        return 'शादी';
      case 'Birthday':
        return 'जन्मदिन';
      case 'Bhandara':
        return 'भंडारा';
      case 'Religious Function':
        return 'धार्मिक कार्यक्रम';
      case 'Family Function':
        return 'पारिवारिक समारोह';
      case 'School Event':
        return 'स्कूल कार्यक्रम';
      case 'Business Order':
        return 'व्यावसायिक ऑर्डर';
      case 'Catering':
        return 'कैटरिंग';
      default:
        return 'अन्य';
    }
  }
}
