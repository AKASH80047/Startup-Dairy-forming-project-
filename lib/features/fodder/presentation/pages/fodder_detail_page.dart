import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/web_image_helper.dart';
import '../../domain/entities/fodder_item_entity.dart';

class FodderDetailPage extends StatelessWidget {
  final FodderItemEntity item;

  const FodderDetailPage({
    super.key,
    required this.item,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final title = isHindi ? item.titleHi : item.titleEn;
    final category = isHindi ? item.categoryHi : item.categoryEn;
    final unit = isHindi ? item.unitHi : item.unitEn;
    final qty = '${item.quantity.toStringAsFixed(0)} $unit';
    final price = '₹${item.price.toStringAsFixed(0)}';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'चारे का विवरण' : 'Fodder Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero image with Category tag
            Container(
              height: 250,
              color: AppConstants.dividerColor,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    path: item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Category tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppConstants.accentGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: AppConstants.primaryGreenDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        isHindi ? 'विक्रेता लिस्टिंग' : 'Seller Listing',
                        style: TextStyle(
                          color: AppConstants.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppConstants.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(height: 20),

                  // Info specs cards (Quantity, Price, Delivery)
                  Row(
                    children: [
                      Expanded(
                        child: _buildSpecItem(
                          context,
                          Icons.inventory_2_rounded,
                          isHindi ? 'कुल मात्रा' : 'Available Qty',
                          qty,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSpecItem(
                          context,
                          Icons.local_shipping_rounded,
                          isHindi ? 'डिलीवरी' : 'Delivery',
                          item.deliveryAvailable
                              ? (isHindi ? 'उपलब्ध है' : 'Available')
                              : (isHindi ? 'उपलब्ध नहीं' : 'Self Pickup'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHindi ? 'चारे की कीमत (दर)' : 'Fodder Rate',
                              style: TextStyle(
                                color: AppConstants.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$price/$unit',
                              style: TextStyle(
                                color: AppConstants.primaryGreen,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.payments_outlined,
                          color: AppConstants.primaryGreen,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Location Details section
                  Text(
                    isHindi ? 'स्थान का विवरण' : 'Location Details',
                    style: TextStyle(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    Icons.pin_drop_rounded,
                    isHindi ? 'गांव' : 'Village',
                    item.village,
                  ),
                  _buildDetailRow(
                    context,
                    Icons.map_rounded,
                    isHindi ? 'जिला' : 'District',
                    item.district,
                  ),
                  _buildDetailRow(
                    context,
                    Icons.flag_rounded,
                    isHindi ? 'राज्य' : 'State',
                    item.state,
                  ),

                  const SizedBox(height: 28),

                  // Seller Profile card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppConstants.dividerColor, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppConstants.primaryGreen.withValues(alpha: 0.1),
                              child: Text(
                                item.sellerName.isNotEmpty ? item.sellerName[0] : 'K',
                                style: TextStyle(
                                  color: AppConstants.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.sellerName,
                                    style: TextStyle(
                                      color: AppConstants.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    isHindi ? 'किसान / विक्रेता' : 'Farmer / Seller',
                                    style: TextStyle(
                                      color: AppConstants.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _makePhoneCall(item.sellerPhone),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.phone_rounded, color: Colors.white),
                          label: Text(
                            isHindi ? 'विक्रेता से संपर्क करें' : 'Contact Seller',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(BuildContext context, IconData icon, String label, String val) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.dividerColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppConstants.accentGold),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(color: AppConstants.textSecondary, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            val,
            style: TextStyle(
              color: AppConstants.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppConstants.textSecondary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(color: AppConstants.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(color: AppConstants.textPrimary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
