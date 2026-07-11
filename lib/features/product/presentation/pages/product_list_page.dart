import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shimmer_loader.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
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
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return _buildShimmerGrid();
            } else if (state is ProductLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noProductsMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(20.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(context, products[index], isHindi, l10n);
                },
              );
            } else if (state is ProductError) {
              return _buildErrorWidget(context, state.message, l10n);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
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

    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.textSecondary.withValues(alpha: 0.04),
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const ShimmerLoader(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 0,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppConstants.dividerColor,
                      child: const Icon(Icons.broken_image_rounded, size: 36),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prodName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppConstants.primaryGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    prodDesc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Price and unit tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppConstants.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                          ),
                          Text(
                            prodUnit,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontSize: 10,
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
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
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
