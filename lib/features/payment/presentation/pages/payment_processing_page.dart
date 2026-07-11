import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import '../../../checkout/presentation/bloc/checkout_cubit.dart';
import '../../../checkout/presentation/bloc/checkout_state.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../../domain/entities/payment_session.dart';

class PaymentProcessingPage extends StatefulWidget {
  final OrderEntity order;
  final String method;
  final String? utr;
  final PaymentSession? session;

  const PaymentProcessingPage({
    super.key,
    required this.order,
    required this.method,
    this.utr,
    this.session,
  });

  @override
  State<PaymentProcessingPage> createState() => _PaymentProcessingPageState();
}

class _PaymentProcessingPageState extends State<PaymentProcessingPage> {
  String _statusText = 'Initializing checkout...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startProcess();
      }
    });
  }

  void _startProcess() async {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    if (widget.method == 'cod') {
      setState(() {
        _statusText = isHindi ? 'ऑर्डर दर्ज किया जा रहा है...' : 'Logging order details...';
      });
      final codOrder = widget.order.copyWith(paymentMethod: 'cod');
      context.read<CheckoutCubit>().placeOrder(codOrder);
    } else if (widget.method == 'credit') {
      setState(() {
        _statusText = isHindi ? 'खाते में दर्ज किया जा रहा है...' : 'Logging to Khata ledger...';
      });
      final creditOrder = widget.order.copyWith(paymentMethod: 'credit');
      context.read<CheckoutCubit>().placeOrder(creditOrder);
    } else if (widget.method == 'qrManual') {
      setState(() {
        _statusText = isHindi ? 'UTR नंबर सत्यापित किया जा रहा है...' : 'Verifying UTR Reference ID...';
      });
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      final qrOrder = widget.order.copyWith(paymentMethod: 'qr');
      context.read<CheckoutCubit>().placeOrder(qrOrder);
    } else {
      setState(() {
        _statusText = isHindi ? 'सुरक्षित गेटवे लोड हो रहा है...' : 'Launching secure payment page...';
      });
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _launchMockSdk();
    }
  }

  void _launchMockSdk() {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.shield_rounded, color: AppConstants.primaryGreen),
            const SizedBox(width: 8),
            Text(isHindi ? 'ऑनलाइन गेटवे' : 'Gateway Checkout'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHindi ? 'भुगतान विवरण:' : 'Payment Information:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text('${isHindi ? "ऑर्डर" : "Order"}: ${widget.order.id}'),
            Text('${isHindi ? "राशि" : "Amount"}: ₹${widget.order.grandTotal.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            Text(
              isHindi ? 'एक विकल्प चुनें:' : 'Simulate gateway action:',
              style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<PaymentBloc>().add(const PaymentClientFailureReceived('Transaction cancelled by customer'));
            },
            child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<PaymentBloc>().add(PaymentClientSuccessReceived(
                    paymentAttemptId: widget.session?.paymentAttemptId ?? 'ATTEMPT_123',
                    gatewayPaymentId: 'pay_gateway_${DateTime.now().millisecondsSinceEpoch}',
                    signature: 'sig_${DateTime.now().millisecondsSinceEpoch}',
                  ));
            },
            child: Text(isHindi ? 'भुगतान सफल' : 'Pay Success'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<CheckoutCubit, CheckoutState>(
          listener: (context, state) {
            if (state is CheckoutSuccess) {
              context.read<CartCubit>().clearCart();
              if (widget.method == 'qrManual') {
                context.go('/payment-pending', extra: {
                  'order': state.order,
                  'utr': widget.utr,
                });
              } else {
                context.go('/payment-success', extra: state.order);
              }
            } else if (state is CheckoutError) {
              context.go('/payment-failed', extra: {
                'order': widget.order,
                'message': state.message,
              });
            }
          },
        ),
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              final paidOrder = widget.order.copyWith(paymentMethod: 'upi');
              context.read<CheckoutCubit>().placeOrder(paidOrder);
            } else if (state is PaymentVerificationPending) {
              final pendingOrder = widget.order.copyWith(paymentMethod: 'upi');
              context.read<CheckoutCubit>().placeOrder(pendingOrder);
            } else if (state is PaymentFailure) {
              context.go('/payment-failed', extra: {
                'order': widget.order,
                'message': state.errorMessage,
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppConstants.backgroundCream,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppConstants.primaryGreen),
                const SizedBox(height: 24),
                Text(
                  l10n.paymentProcessing,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _statusText,
                  style: TextStyle(color: AppConstants.textSecondary, fontStyle: FontStyle.italic, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
