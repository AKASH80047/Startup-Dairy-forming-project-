import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../checkout/domain/entities/order_entity.dart';

class PaymentSuccessPage extends StatelessWidget {
  final OrderEntity order;

  const PaymentSuccessPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withOpacity(0.08),
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

              Text(
                l10n.paymentSuccessful,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),

              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildRow(l10n.orderIdLabel, order.id),
                      Divider(height: 24, color: AppConstants.dividerColor),
                      _buildRow(
                        l10n.amountLabel,
                        '₹${order.grandTotal.toStringAsFixed(0)}',
                        valueColor: AppConstants.primaryGreen,
                        valueWeight: FontWeight.bold,
                      ),
                      Divider(height: 24, color: AppConstants.dividerColor),
                      _buildRow(
                        isHindi ? 'भुगतान का प्रकार' : 'Payment Method',
                        order.paymentMethod.toUpperCase(),
                      ),
                      Divider(height: 24, color: AppConstants.dividerColor),
                      _buildRow(
                        l10n.statusLabel,
                        l10n.paidLabel,
                        valueColor: AppConstants.primaryGreen,
                        valueWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: Text(isHindi ? 'होम स्क्रीन पर जाएं' : 'Back to Home'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/order-history'),
                  child: Text(isHindi ? 'ऑर्डर इतिहास देखें' : 'View Order History'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppConstants.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: valueWeight ?? FontWeight.w600,
            color: valueColor ?? AppConstants.textPrimary,
          ),
        ),
      ],
    );
  }
}
