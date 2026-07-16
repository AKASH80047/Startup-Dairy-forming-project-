import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/utils/web_image_helper.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import '../../domain/entities/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'आपका कार्ट' : 'My Cart'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
            },
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
            tooltip: isHindi ? 'कार्ट खाली करें' : 'Clear Cart',
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final cart = state.cart;

            if (cart.items.isEmpty) {
              return _buildEmptyCart(context, isHindi, l10n);
            }

            return Column(
              children: [
                // List of cart items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return _buildCartItemCard(context, cart.items[index], isHindi, l10n);
                    },
                  ),
                ),
                
                // Delivery address selection / distance banner
                _buildDeliveryLocationSection(context, cart, isHindi, l10n),
                
                // Bill summary & checkout CTA
                _buildBillSummarySection(context, cart, isHindi, l10n),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context, bool isHindi, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 80,
                color: AppConstants.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isHindi ? 'आपका कार्ट खाली है' : 'Your Cart is Empty',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppConstants.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              isHindi
                  ? 'डेयरी उत्पादों की विस्तृत सूची देखें और अपने कार्ट में जोड़ें।'
                  : 'Browse our fresh dairy collection and add items to your cart.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                child: Text(isHindi ? 'खरीदारी शुरू करें' : 'Shop Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    CartItem item,
    bool isHindi,
    AppLocalizations l10n,
  ) {
    final String name = isHindi ? item.nameHindi : item.nameEnglish;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.dividerColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImage(
              path: item.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const ShimmerLoader(width: 72, height: 72, borderRadius: 12);
              },
              errorBuilder: (context, error, stackTrace) => Container(
                width: 72,
                height: 72,
                color: AppConstants.dividerColor,
                child: const Icon(Icons.broken_image_rounded, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppConstants.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.priceLabel}: ₹${item.price.toStringAsFixed(0)} / ${item.unit}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Subtotal: ₹${item.subtotal.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
          
          // Quantity Selector
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.remove_circle_outline, color: AppConstants.primaryGreen),
                    onPressed: () {
                      context.read<CartCubit>().updateQuantity(item.id, item.quantity - 1);
                    },
                  ),
                  Text(
                    '${item.quantity}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.add_circle_outline, color: AppConstants.primaryGreen),
                    onPressed: () {
                      context.read<CartCubit>().updateQuantity(item.id, item.quantity + 1);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryLocationSection(
    BuildContext context,
    dynamic cart,
    bool isHindi,
    AppLocalizations l10n,
  ) {
    final double? distance = cart.deliveryDistance;
    final bool locationSet = distance != null;
    final bool isTooFar = locationSet && distance > 10.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        border: Border(
          top: BorderSide(color: AppConstants.dividerColor, width: 0.5),
          bottom: BorderSide(color: AppConstants.dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.pin_drop_rounded,
            color: AppConstants.accentGold,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'डिलीवरी का स्थान' : 'Delivery Address',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppConstants.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  locationSet
                      ? (isTooFar
                          ? (isHindi
                              ? 'दूरी: ${distance.toStringAsFixed(1)} किमी (डिलीवरी सीमा से बाहर)'
                              : 'Distance: ${distance.toStringAsFixed(1)} km (Out of boundary)')
                          : (isHindi
                              ? 'दूरी: ${distance.toStringAsFixed(1)} किमी'
                              : 'Distance: ${distance.toStringAsFixed(1)} km'))
                      : (isHindi ? 'पता सेट नहीं है' : 'Address not set'),
                  style: TextStyle(
                    fontSize: 12,
                    color: isTooFar ? Colors.redAccent : AppConstants.textSecondary,
                    fontWeight: locationSet ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation trigger button
          ElevatedButton(
            onPressed: () {
              context.push('/map-picker');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              backgroundColor: AppConstants.primaryGreen.withValues(alpha: 0.06),
              foregroundColor: AppConstants.primaryGreen,
            ),
            child: Text(
              locationSet
                  ? (isHindi ? 'बदलें' : 'Change')
                  : (isHindi ? 'नक्शे पर चुनें' : 'Map Pin'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummarySection(
    BuildContext context,
    dynamic cart,
    bool isHindi,
    AppLocalizations l10n,
  ) {
    final double? distance = cart.deliveryDistance;
    final bool locationSet = distance != null;
    final bool isTooFar = locationSet && distance > 10.0;
    
    final double deliveryFee = cart.deliveryCharge;
    final double subtotal = cart.subtotal;
    final double grandTotal = cart.grandTotal;

    return Container(
      color: AppConstants.surfaceWhite,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Subtotal Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'कुल योग (सबटोटल)' : 'Subtotal',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '₹${subtotal.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryGreen,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Delivery Charge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'डिलीवरी शुल्क' : 'Delivery Charge',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                !locationSet
                    ? (isHindi ? 'लोकेशन चुनें' : 'Select Location')
                    : (isTooFar
                        ? (isHindi ? 'अनुपलब्ध' : 'Unavailable')
                        : (deliveryFee == 0.0
                            ? (isHindi ? 'मुफ़्त' : 'FREE')
                            : '₹${deliveryFee.toStringAsFixed(0)}')),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isTooFar ? Colors.redAccent : AppConstants.primaryGreen,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: AppConstants.dividerColor),
          const SizedBox(height: 12),
          
          // Grand Total Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'कुल देय राशि' : 'Grand Total',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
              ),
              Text(
                '₹${(isTooFar ? subtotal : grandTotal).toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Checkout Trigger Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!locationSet) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isHindi
                            ? 'आगे बढ़ने के लिए कृपया पहले अपनी डिलीवरी लोकेशन चुनें!'
                            : 'Please select your delivery location before proceeding!',
                      ),
                      backgroundColor: AppConstants.accentOrange,
                      action: SnackBarAction(
                        label: isHindi ? 'लोकेशन चुनें' : 'Set Location',
                        textColor: Colors.white,
                        onPressed: () => context.push('/map-picker'),
                      ),
                    ),
                  );
                  return;
                }
                if (isTooFar) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(isHindi ? 'सीमा से बाहर' : 'Delivery Out of Range'),
                      content: Text(
                        isHindi
                            ? 'क्षमा करें, हम केवल १० किमी के भीतर डिलीवरी करते हैं। क्या आप परीक्षण (Test Mode) के लिए आगे बढ़ना चाहते हैं?'
                            : 'Sorry, we only deliver within 10 km. Would you like to bypass this for testing?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<CartCubit>().updateDeliveryDistance(1.0);
                            context.push('/checkout');
                          },
                          child: Text(
                            isHindi ? 'बायपास करें (Test Mode)' : 'Bypass (Test Mode)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                context.push('/checkout');
              },
              child: Text(isHindi ? 'चेकआउट के लिए आगे बढ़ें' : 'Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
