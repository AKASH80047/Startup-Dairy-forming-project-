import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/order_entity.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<OrderEntity> _orders = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHistory();
  }

  void _loadHistory() {
    final storage = context.read<StorageService>();
    setState(() {
      _orders = storage.getOrderHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.orderHistoryTitle),
        elevation: 0,
        actions: [
          if (_orders.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
              tooltip: l10n.clearHistoryLabel,
              onPressed: () async {
                final storage = context.read<StorageService>();
                await storage.clearOrderHistory();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.clearHistorySuccess)),
                );
                _loadHistory();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: _orders.isEmpty
            ? _buildEmptyHistory(context, isHindi, l10n)
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return _buildOrderHistoryCard(context, _orders[index], isHindi, l10n);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyHistory(BuildContext context, bool isHindi, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: AppConstants.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noOrdersMessage,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppConstants.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              isHindi
                  ? 'आपके द्वारा सबमिट किए गए ऑर्डर यहाँ दिखाई देंगे।'
                  : 'Your successfully placed orders will be cached and listed here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text(isHindi ? 'ऑर्डर करना शुरू करें' : 'Order Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHistoryCard(
    BuildContext context,
    OrderEntity order,
    bool isHindi,
    AppLocalizations l10n,
  ) {
    final String dateString = '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';
    final String timeString = '${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppConstants.dividerColor, width: 0.5),
      ),
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.all(16),
        iconColor: AppConstants.primaryGreen,
        collapsedIconColor: AppConstants.textSecondary,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppConstants.primaryGreen.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.shopping_bag_outlined, color: AppConstants.primaryGreen, size: 24),
        ),
        title: Text(
          order.id,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text(
          '${l10n.placedOnLabel}: $dateString $timeString • Total: ₹${order.grandTotal.toStringAsFixed(0)}',
          style: const TextStyle(color: AppConstants.textSecondary, fontSize: 10),
        ),
        children: [
          const Divider(color: AppConstants.dividerColor),
          const SizedBox(height: 8),

          // Items summary
          const Text(
            'Items Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppConstants.textSecondary),
          ),
          const SizedBox(height: 6),
          ...order.items.map((item) {
            final String name = isHindi ? item.nameHindi : item.nameEnglish;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('- $name (${item.unit} x ${item.quantity})', style: const TextStyle(fontSize: 12)),
                  Text('₹${item.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),

          // Delivery details
          const Text(
            'Delivery Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppConstants.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            order.address.addressLine,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Text(
            'Village: ${order.address.village} • Pincode: ${order.address.pincode}',
            style: const TextStyle(fontSize: 10, color: AppConstants.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            'Slot: ${order.deliverySlot == "morning" ? "Morning (6 AM - 9 AM)" : "Evening (5 PM - 8 PM)"}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppConstants.primaryGreen),
          ),
          Text(
            'Payment: ${order.paymentMethod == "cod" ? "Cash on Delivery" : "Village Credit"}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppConstants.accentGold),
          ),
        ],
      ),
    );
  }
}
