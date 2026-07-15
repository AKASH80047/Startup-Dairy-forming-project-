import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enum/animal_type.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/utils/web_image_helper.dart';
import '../bloc/breed_cubit.dart';
import '../bloc/breed_state.dart';
import '../../domain/entities/breed_entity.dart';

class BreedListPage extends StatefulWidget {
  final AnimalType animalType;

  const BreedListPage({
    super.key,
    required this.animalType,
  });

  @override
  State<BreedListPage> createState() => _BreedListPageState();
}

class _BreedListPageState extends State<BreedListPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch fetch event on initial load
    context.read<BreedCubit>().fetchBreeds(widget.animalType);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isCow = widget.animalType == AnimalType.cow;
    final String pageTitle = isCow ? l10n.cowBreedsTitle : l10n.buffaloBreedsTitle;
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(pageTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<BreedCubit, BreedState>(
          builder: (context, state) {
            if (state is BreedLoading) {
              return _buildShimmerList();
            } else if (state is BreedLoaded) {
              final breeds = state.breeds;
              if (breeds.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noBreedsMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: breeds.length,
                itemBuilder: (context, index) {
                  return _buildBreedCard(context, breeds[index], isHindi, l10n);
                },
              );
            } else if (state is BreedError) {
              return _buildErrorWidget(context, state.message, l10n);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ShimmerLoader(
            width: double.infinity,
            height: 280,
            borderRadius: 20,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBreedCard(
    BuildContext context,
    BreedEntity breed,
    bool isHindi,
    AppLocalizations l10n,
  ) {
    final String breedName = isHindi ? breed.nameHindi : breed.nameEnglish;
    final String breedOrigin = isHindi ? breed.originHindi : breed.originEnglish;
    final String breedDesc = isHindi ? breed.descriptionHindi : breed.descriptionEnglish;

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.textSecondary.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppConstants.dividerColor,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          context.push('/breed-detail/${breed.id}');
        },
        borderRadius: BorderRadius.circular(19),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Breed image with tag overlays
              Container(
                height: 180,
                color: const Color(0xFFF3F6F4),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      getWebSafeImageUrl(breed.imageUrl),
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const ShimmerLoader(
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: 0,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppConstants.dividerColor,
                          child: Icon(
                            Icons.broken_image_rounded,
                            size: 48,
                            color: AppConstants.textSecondary,
                          ),
                        );
                      },
                    ),
                    // Gradient shadow
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Availability Badge (Top Right)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: breed.isAvailable
                              ? AppConstants.primaryGreen
                              : AppConstants.textSecondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          breed.isAvailable ? l10n.availableLabel : l10n.outOfStockLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Breed Title overlay (Bottom Left)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            breedName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Details section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Origin row
                    Row(
                      children: [
                        Icon(
                          Icons.pin_drop_rounded,
                          size: 16,
                          color: AppConstants.accentGold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${l10n.originLabel}: ',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textSecondary,
                              ),
                        ),
                        Text(
                          breedOrigin,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppConstants.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Description snippet
                    Text(
                      breedDesc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppConstants.textSecondary,
                            height: 1.3,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppConstants.dividerColor),
                    const SizedBox(height: 16),
                    
                    // Primary Info (Price per Litre + CTA Action)
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
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                text: '₹${breed.pricePerLitre.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppConstants.primaryGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                children: [
                                  TextSpan(
                                    text: isHindi ? '/लीटर' : '/L',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppConstants.textSecondary,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.push('/breed-detail/${breed.id}');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(isHindi ? 'विवरण देखें' : 'View Details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                context.read<BreedCubit>().fetchBreeds(widget.animalType);
              },
              child: Text(isHindi ? 'पुनः प्रयास करें' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
