import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/utils/web_image_helper.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';
import '../../domain/entities/product_entity.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<Map<String, String>> _categories = [
    {'en': 'All', 'hi': 'सभी'},
    {'en': 'Milk', 'hi': 'दूध'},
    {'en': 'Ghee', 'hi': 'घी'},
    {'en': 'Paneer', 'hi': 'पनीर'},
    {'en': 'Curd', 'hi': 'दही'},
    {'en': 'Buttermilk', 'hi': 'छाछ'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.otherProductsTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // E-commerce Search & Categories Filter Panel
            _buildFilterHeader(isHindi),

            // Product Grid
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return _buildShimmerGrid();
                  } else if (state is ProductLoaded) {
                    final query = _searchController.text.trim().toLowerCase();
                    final filteredProducts = state.products.where((p) {
                      final name = isHindi ? p.nameHindi : p.nameEnglish;
                      final desc = isHindi ? p.descriptionHindi : p.descriptionEnglish;
                      final matchSearch = query.isEmpty ||
                          name.toLowerCase().contains(query) ||
                          desc.toLowerCase().contains(query);

                      final matchCategory = _selectedCategory == 'All' ||
                          p.nameEnglish.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
                          p.nameHindi.contains(_selectedCategory);

                      return matchSearch && matchCategory;
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noProductsMessage,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final double width = constraints.maxWidth;
                        int crossAxisCount = 2;
                        double aspectRatio = 0.70;
                        if (width > 1000) {
                          crossAxisCount = 5;
                          aspectRatio = 0.82;
                        } else if (width > 600) {
                          crossAxisCount = 3;
                          aspectRatio = 0.74;
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: aspectRatio,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(context, filteredProducts[index], isHindi, l10n);
                          },
                        );
                      },
                    );
                  } else if (state is ProductError) {
                    return _buildErrorWidget(context, state.message, l10n);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterHeader(bool isHindi) {
    return Container(
      color: AppConstants.surfaceWhite,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: isHindi ? 'उत्पाद खोजें...' : 'Search dairy products...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal Category Tabs
          SizedBox(
            height: 38,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final catName = isHindi ? cat['hi']! : cat['en']!;
                final isSelected = _selectedCategory == cat['en'];

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
                        _selectedCategory = cat['en']!;
                      });
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

  Widget _buildShimmerGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int crossAxisCount = 2;
        double aspectRatio = 0.70;
        if (width > 1000) {
          crossAxisCount = 5;
          aspectRatio = 0.82;
        } else if (width > 600) {
          crossAxisCount = 3;
          aspectRatio = 0.74;
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: aspectRatio,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return ShimmerLoader(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductEntity product,
    bool isHindi,
    AppLocalizations l10n,
  ) {
    final String prodName = isHindi ? product.nameHindi : product.nameEnglish;
    final String prodDesc = isHindi ? product.descriptionHindi : product.descriptionEnglish;
    final String prodUnit = isHindi ? product.unitHindi : product.unitEnglish;
    final double originalPrice = product.price * 1.15; // Mock original price

    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppConstants.dividerColor,
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product image
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    path: product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.25),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Rating Badge
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '4.9 ★',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Discount Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '15% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (!product.isAvailable)
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            l10n.outOfStockLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Product details & price tag
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prodName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppConstants.primaryGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      prodDesc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppConstants.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    
                    // Price and unit tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${originalPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: AppConstants.textSecondary,
                                fontSize: 9,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '₹${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: AppConstants.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              prodUnit,
                              style: TextStyle(
                                color: AppConstants.textSecondary,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                        
                        // Quick Add button
                        if (product.isAvailable)
                          GestureDetector(
                            onTap: () {
                              final item = CartItem(
                                id: '${product.id}_standard',
                                productId: product.id,
                                nameEnglish: product.nameEnglish,
                                nameHindi: product.nameHindi,
                                imageUrl: product.imageUrl,
                                price: product.price,
                                unit: product.unitEnglish,
                                quantity: 1,
                                isMilk: false,
                              );
                              context.read<CartCubit>().addItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.productAdded)),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
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

  Widget _buildErrorWidget(
    BuildContext context,
    String error,
    AppLocalizations l10n,
  ) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';
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
                context.read<ProductCubit>().fetchProducts();
              },
              child: Text(isHindi ? 'पुनः प्रयास करें' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
