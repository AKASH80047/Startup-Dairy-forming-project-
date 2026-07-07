import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enum/a2_status.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../bloc/breed_cubit.dart';
import '../bloc/breed_state.dart';
import '../../domain/entities/breed_entity.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';

class BreedDetailPage extends StatefulWidget {
  final String breedId;

  const BreedDetailPage({
    super.key,
    required this.breedId,
  });

  @override
  State<BreedDetailPage> createState() => _BreedDetailPageState();
}

class _BreedDetailPageState extends State<BreedDetailPage> {
  String _selectedQuantity = '1L';
  final TextEditingController _customQtyController = TextEditingController();
  bool _isCustomQty = false;

  @override
  void initState() {
    super.initState();
    context.read<BreedCubit>().fetchBreedDetail(widget.breedId);
  }

  @override
  void dispose() {
    _customQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      body: BlocBuilder<BreedCubit, BreedState>(
        builder: (context, state) {
          if (state is BreedLoading) {
            return _buildShimmerBody();
          } else if (state is BreedDetailLoaded) {
            return _buildContentBody(context, state.breed, isHindi, l10n);
          } else if (state is BreedError) {
            return _buildErrorBody(context, state.message, l10n, isHindi);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildShimmerBody() {
    return const Column(
      children: [
        ShimmerLoader(width: double.infinity, height: 300, borderRadius: 0),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoader(width: 200, height: 28),
                SizedBox(height: 16),
                ShimmerLoader(width: double.infinity, height: 100),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: ShimmerLoader(width: 80, height: 60)),
                    SizedBox(width: 16),
                    Expanded(child: ShimmerLoader(width: 80, height: 60)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentBody(
    BuildContext context,
    BreedEntity breed,
    bool isHindi,
    AppLocalizations l10n,
  ) {
    final String breedName = isHindi ? breed.nameHindi : breed.nameEnglish;
    final String breedOrigin = isHindi ? breed.originHindi : breed.originEnglish;
    final String breedDesc = isHindi ? breed.descriptionHindi : breed.descriptionEnglish;
    final String breedVillage = isHindi ? breed.sourceVillageHindi : breed.sourceVillageEnglish;

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero collapsing banner
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'breed_img_${breed.id}',
                        child: Image.network(
                          breed.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppConstants.dividerColor,
                            child: const Icon(Icons.broken_image_rounded, size: 64),
                          ),
                        ),
                      ),
                      // Top-down and bottom-up shadow gradients
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                              Colors.black.withOpacity(0.45),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Information details
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and origin heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    breedName,
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          color: AppConstants.primaryGreen,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    breedOrigin,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppConstants.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: breed.isAvailable 
                                    ? AppConstants.primaryGreen.withOpacity(0.08)
                                    : Colors.redAccent.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                breed.isAvailable ? l10n.availableLabel : l10n.outOfStockLabel,
                                style: TextStyle(
                                  color: breed.isAvailable ? AppConstants.primaryGreen : Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),

                        // SPECIFICATIONS GRID
                        _buildSpecsGrid(context, breed, l10n, isHindi, breedVillage),
                        
                        const SizedBox(height: 24),

                        // A2 Status Notice Box (compliance check)
                        _buildA2StatusWidget(context, breed.a2Status, l10n),
                        
                        const SizedBox(height: 24),

                        // Description
                        Text(
                          isHindi ? 'विशेषताएं' : 'Key Characteristics',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppConstants.primaryGreen,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          breedDesc,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                              ),
                        ),
                        
                        const SizedBox(height: 24),

                        // Yield and Fat disclaimer
                        _buildDisclaimerWidget(isHindi),
                        
                        const SizedBox(height: 24),

                        // QUANTITY SELECTOR
                        Text(
                          l10n.selectQuantityLabel,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppConstants.primaryGreen,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildQuantitySelector(isHindi, l10n),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        
        // BOTTOM ACTION FOOTER
        _buildActionFooter(context, breed, l10n, isHindi),
      ],
    );
  }

  Widget _buildSpecsGrid(
    BuildContext context, 
    BreedEntity breed, 
    AppLocalizations l10n, 
    bool isHindi,
    String village,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: [
        _buildSpecCard(
          context,
          Icons.pin_drop_rounded,
          l10n.sourceVillageLabel,
          village,
        ),
        _buildSpecCard(
          context,
          Icons.water_drop_rounded,
          l10n.fatPercentageLabel,
          '${breed.averageFatMin}% - ${breed.averageFatMax}%',
        ),
        _buildSpecCard(
          context,
          Icons.speed_rounded,
          l10n.yieldLabel,
          '${breed.averageYieldMin.toStringAsFixed(0)}-${breed.averageYieldMax.toStringAsFixed(0)} ${isHindi ? 'ली/दिन' : 'L/day'}',
        ),
        _buildSpecCard(
          context,
          Icons.local_shipping_rounded,
          isHindi ? 'डिलीवरी शुल्क' : 'Delivery Charge',
          isHindi ? 'मुफ़्त (2 किमी)' : 'Free (within 2km)',
        ),
      ],
    );
  }

  Widget _buildSpecCard(BuildContext context, IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.dividerColor, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppConstants.accentGold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppConstants.textSecondary,
                        fontSize: 10,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildA2StatusWidget(BuildContext context, A2Status status, AppLocalizations l10n) {
    Color cardColor;
    Color textColor;
    String statusText;
    IconData icon;

    switch (status) {
      case A2Status.verified:
        cardColor = AppConstants.primaryGreen.withOpacity(0.06);
        textColor = AppConstants.primaryGreen;
        statusText = l10n.verifiedLabel;
        icon = Icons.verified_rounded;
        break;
      case A2Status.notVerified:
        cardColor = AppConstants.accentOrange.withOpacity(0.08);
        textColor = AppConstants.accentOrange;
        statusText = l10n.notVerifiedLabel;
        icon = Icons.warning_amber_rounded;
        break;
      case A2Status.unknown:
        cardColor = Colors.grey.withOpacity(0.08);
        textColor = AppConstants.textSecondary;
        statusText = '${l10n.a2StatusLabel}: ${l10n.unknownLabel}';
        icon = Icons.help_outline_rounded;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerWidget(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstants.accentGold.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppConstants.accentOrange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isHindi
                  ? '* वसा और उपज के मान बैच परीक्षण पर आधारित औसत संकेतक हैं। वास्तविक परिणाम भिन्न हो सकते हैं।'
                  : '* Fat and yield values are approximate indicators based on farm batch records. Actual test values may vary.',
              style: const TextStyle(
                fontSize: 11,
                color: AppConstants.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(bool isHindi, AppLocalizations l10n) {
    final List<String> options = ['500ml', '1L', '2L', 'Custom'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: options.map((opt) {
            final isSelected = (_isCustomQty && opt == 'Custom') ||
                (!_isCustomQty && _selectedQuantity == opt);
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ChoiceChip(
                label: Text(
                  opt == 'Custom' ? (isHindi ? 'कस्टम' : 'Custom') : opt,
                  style: TextStyle(
                    color: isSelected ? AppConstants.backgroundCream : AppConstants.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppConstants.primaryGreen,
                backgroundColor: AppConstants.surfaceWhite,
                checkmarkColor: AppConstants.backgroundCream,
                onSelected: (val) {
                  setState(() {
                    if (opt == 'Custom') {
                      _isCustomQty = true;
                    } else {
                      _isCustomQty = false;
                      _selectedQuantity = opt;
                    }
                  });
                },
              ),
            );
          }).toList(),
        ),
        if (_isCustomQty) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _customQtyController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: l10n.customQuantityHint,
              filled: true,
              fillColor: AppConstants.surfaceWhite,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppConstants.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppConstants.primaryGreen, width: 1.5),
              ),
              suffixText: 'ml',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionFooter(
    BuildContext context,
    BreedEntity breed,
    AppLocalizations l10n,
    bool isHindi,
  ) {
    final String breedName = isHindi ? breed.nameHindi : breed.nameEnglish;
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
        border: const Border(
          top: BorderSide(color: AppConstants.dividerColor, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pricing Preview Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'मूल्य प्रति लीटर' : 'Price per Litre',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${breed.pricePerLitre.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
                
                // Subscription trigger
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isHindi
                              ? '${breedName} के लिए दैनिक सदस्यता शुरू की जा रही है'
                              : 'Initiating daily subscription setup for ${breed.nameEnglish}',
                        ),
                      ),
                    );
                  },
                  child: Text(l10n.subscribeLabel),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Standard checkout actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isCustomQty) {
                        final int customVal = int.tryParse(_customQtyController.text) ?? 1000;
                        final double customPrice = breed.pricePerLitre * (customVal / 1000.0);
                        final item = CartItem(
                          id: '${breed.id}_custom_${customVal}',
                          productId: breed.id,
                          nameEnglish: '${breed.nameEnglish} Milk (Custom)',
                          nameHindi: '${breed.nameHindi} दूध (कस्टम)',
                          imageUrl: breed.imageUrl,
                          price: customPrice,
                          unit: '${customVal}ml',
                          quantity: 1,
                          isMilk: true,
                        );
                        context.read<CartCubit>().addItem(item);
                      } else {
                        final double factor = _selectedQuantity == '500ml' 
                            ? 0.5 
                            : (_selectedQuantity == '2L' ? 2.0 : 1.0);
                        final item = CartItem(
                          id: '${breed.id}_${_selectedQuantity}',
                          productId: breed.id,
                          nameEnglish: '${breed.nameEnglish} Milk',
                          nameHindi: '${breed.nameHindi} दूध',
                          imageUrl: breed.imageUrl,
                          price: breed.pricePerLitre * factor,
                          unit: _selectedQuantity,
                          quantity: 1,
                          isMilk: true,
                        );
                        context.read<CartCubit>().addItem(item);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.productAdded)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryGreen.withOpacity(0.12),
                      foregroundColor: AppConstants.primaryGreen,
                    ),
                    child: Text(l10n.addToCartLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isHindi ? 'चेकआउट स्क्रीन पर रीडायरेक्ट हो रहा है...' : 'Redirecting to checkout...',
                          ),
                        ),
                      );
                    },
                    child: Text(l10n.buyNowLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBody(
    BuildContext context, 
    String error, 
    AppLocalizations l10n, 
    bool isHindi,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              isHindi ? 'कुछ गलत हो गया' : 'An error occurred',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.redAccent,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<BreedCubit>().fetchBreedDetail(widget.breedId);
              },
              child: Text(isHindi ? 'पुनः प्रयास करें' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
