import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentPendingPage extends StatelessWidget {
  final OrderEntity order;
  final String? utr;

  const PaymentPendingPage({
    super.key,
    required this.order,
    this.utr,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          context.go('/payment-success', extra: order);
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.redAccent),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppConstants.backgroundCream,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppConstants.accentGold.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.hourglass_empty_rounded,
                      size: 88,
                      color: AppConstants.accentGold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.paymentProcessing,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppConstants.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.paymentConfirmingDesc,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                ),
                Text(
                  l10n.doNotPayAgainDesc,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.redAccent,
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
                        ),
                        if (utr != null) ...[
                          Divider(height: 24, color: AppConstants.dividerColor),
                          _buildRow(l10n.utrLabel, utr!),
                        ],
                        Divider(height: 24, color: AppConstants.dividerColor),
                        _buildRow(
                          l10n.statusLabel,
                          l10n.verificationPending,
                          valueColor: AppConstants.accentGold,
                          valueWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),

                BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    final bool isRefreshing = state is PaymentProcessing;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isRefreshing
                            ? null
                            : () {
                                context.read<PaymentBloc>().add(RefreshPaymentStatusRequested(order.id));
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.accentGold,
                        ),
                        child: isRefreshing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(l10n.checkStatusButton),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/home'),
                    child: Text(isHindi ? 'होम स्क्रीन पर जाएं' : 'Back to Home'),
                  ),
                ),
              ],
            ),
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
