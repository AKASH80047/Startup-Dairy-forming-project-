import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/checkout_cubit.dart';
import '../bloc/checkout_state.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';

class MockGatewayPage extends StatefulWidget {
  final OrderEntity order;

  const MockGatewayPage({super.key, required this.order});

  @override
  State<MockGatewayPage> createState() => _MockGatewayPageState();
}

class _MockGatewayPageState extends State<MockGatewayPage> {
  bool _processing = false;
  String _statusText = 'Initializing secure payment session...';

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _statusText = 'Awaiting payment authorization from UPI provider...';
      });
    }
  }

  void _handleSuccess() async {
    setState(() {
      _processing = true;
      _statusText = 'Verifying transaction UTR on blockchain ledger...';
    });
    await Future.delayed(const Duration(milliseconds: 50));
    if (mounted) {
      // Complete order creation
      context.read<CheckoutCubit>().placeOrder(widget.order);
      // Wait for cubit success handler to redirect
    }
  }

  void _handleFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment authorization failed: Transaction cancelled by user.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    context.pop(); // Return to checkout page
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          // Clear shopping cart
          context.read<CartCubit>().clearCart();
          // Navigate to success screen
          context.go('/order-success', extra: state.order);
        } else if (state is CheckoutError) {
          setState(() {
            _processing = false;
            _statusText = 'Checkout placement failed.';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppConstants.backgroundCream,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Secure Shield Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    size: 72,
                    color: AppConstants.primaryGreen,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Gateway Title
                Text(
                  isHindi ? 'पांडेय सुरक्षित भुगतान गेटवे' : 'Pandey Secure Pay Gateway',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  isHindi
                      ? 'कृपया इस स्क्रीन को बंद न करें या पीछे न जाएं'
                      : 'Please do not close this window or navigate back.',
                  style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 32),
                
                // Transaction Details Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isHindi ? 'कुल देय राशि:' : 'Amount Payable:',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Text(
                              '₹${widget.order.grandTotal.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppConstants.primaryGreen),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: AppConstants.dividerColor),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isHindi ? 'ट्रांजैक्शन आईडी:' : 'Reference ID:',
                              style: TextStyle(color: AppConstants.textSecondary, fontSize: 11),
                            ),
                            Text(
                              widget.order.id,
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppConstants.textPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Loader & Status
                if (_processing) ...[
                  CircularProgressIndicator(color: AppConstants.primaryGreen),
                  const SizedBox(height: 16),
                ],
                Text(
                  _statusText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppConstants.textSecondary, fontSize: 13, fontStyle: FontStyle.italic),
                ),
                
                const Spacer(),
                
                // Simulation Control Buttons (visible when not processing checkouts)
                if (!_processing) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                          ),
                          onPressed: _handleFailure,
                          child: Text(isHindi ? 'भुगतान रद्द करें' : 'Cancel/Fail'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSuccess,
                          child: Text(isHindi ? 'सफल भुगतान करें' : 'Authorize Success'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
