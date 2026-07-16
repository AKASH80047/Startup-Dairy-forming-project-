import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/web_image_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/fodder_cubit.dart';
import '../bloc/fodder_state.dart';
import '../../domain/entities/fodder_item_entity.dart';

class FodderMarketplacePage extends StatefulWidget {
  const FodderMarketplacePage({super.key});

  @override
  State<FodderMarketplacePage> createState() => _FodderMarketplacePageState();
}

class _FodderMarketplacePageState extends State<FodderMarketplacePage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  final List<Map<String, String>> _categories = [
    {'en': 'All', 'hi': 'सभी'},
    {'en': 'Bhusa', 'hi': 'भूसा'},
    {'en': 'Dry Grass', 'hi': 'सूखी घास'},
    {'en': 'Green Grass', 'hi': 'हरी घास'},
    {'en': 'Silage', 'hi': 'साइलेज'},
    {'en': 'Napier', 'hi': 'नेपियर'},
    {'en': 'Berseem', 'hi': 'बरसीम'},
    {'en': 'Maize Fodder', 'hi': 'मक्का चारा'},
    {'en': 'Animal Feed', 'hi': 'पशु आहार'},
    {'en': 'Mineral Mixture', 'hi': 'खनिज मिश्रण'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<FodderCubit>().fetchFodderItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    final query = _searchController.text.trim();
    context.read<FodderCubit>().fetchFodderItems(
          category: _selectedCategory == 'All' ? null : _selectedCategory,
          search: query.isEmpty ? null : query,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'चारा बाजार' : 'Fodder Marketplace'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Category Bar
            _buildSearchAndFilters(isHindi),

            // Main Content Area
            Expanded(
              child: BlocBuilder<FodderCubit, FodderState>(
                builder: (context, state) {
                  if (state is FodderLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  } else if (state is FodderLoaded) {
                    final items = state.items;
                    if (items.isEmpty) {
                      return _buildEmptyState(isHindi);
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<FodderCubit>().fetchFodderItems(
                              category: _selectedCategory == 'All' ? null : _selectedCategory,
                              search: _searchController.text.isEmpty ? null : _searchController.text,
                            );
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return _buildFodderCard(context, items[index], isHindi);
                        },
                      ),
                    );
                  } else if (state is FodderError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/upload-fodder'),
        backgroundColor: AppConstants.primaryGreen,
        icon: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        label: Text(
          isHindi ? 'बेचना शुरू करें' : 'Sell Fodder',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isHindi) {
    return Container(
      color: AppConstants.surfaceWhite,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppConstants.dividerColor, width: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: AppConstants.textSecondary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => _triggerSearch(),
                            decoration: InputDecoration(
                              hintText: isHindi ? 'चारा खोजें...' : 'Search fodder items...',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Categories horizontal scroll list
          SizedBox(
            height: 38,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final catName = isHindi ? cat['hi']! : cat['en']!;
                final isSelected = (_selectedCategory == cat['en']) ||
                    (_selectedCategory == null && cat['en'] == 'All');

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      catName,
                      style: TextStyle(
                        color: isSelected ? AppConstants.backgroundCream : AppConstants.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppConstants.primaryGreen,
                    backgroundColor: AppConstants.backgroundCream,
                    checkmarkColor: AppConstants.backgroundCream,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat['en'] == 'All' ? null : cat['en'];
                      });
                      _triggerSearch();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFodderCard(BuildContext context, FodderItemEntity item, bool isHindi) {
    final title = isHindi ? item.titleHi : item.titleEn;
    final price = '₹${item.price.toStringAsFixed(0)}';
    final unit = isHindi ? item.unitHi : item.unitEn;
    final qty = '${item.quantity.toStringAsFixed(0)} $unit';

    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.dividerColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push('/fodder-detail', extra: item);
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fodder Image with tags overlay
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppImage(
                      path: item.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppConstants.accentGold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isHindi ? item.categoryHi : item.categoryEn,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card Details
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppConstants.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${isHindi ? "मात्रा" : "Qty"}: $qty',
                      style: TextStyle(
                        color: AppConstants.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: AppConstants.accentGold),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${item.village}, ${item.district}',
                            style: TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHindi ? 'दर' : 'Rate',
                              style: TextStyle(
                                color: AppConstants.textSecondary,
                                fontSize: 9,
                              ),
                            ),
                            Text(
                              '$price/$unit',
                              style: TextStyle(
                                color: AppConstants.primaryGreen,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isHindi) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.grass_rounded, size: 64, color: AppConstants.dividerColor),
          const SizedBox(height: 12),
          Text(
            isHindi ? 'कोई चारा नहीं मिला' : 'No fodder items listed',
            style: TextStyle(color: AppConstants.textSecondary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            isHindi
                ? 'अलग खोज करने का प्रयास करें।'
                : 'Try modifying search criteria.',
            style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
