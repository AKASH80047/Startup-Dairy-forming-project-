import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enum/theme_type.dart';
import '../../../language/presentation/bloc/language_cubit.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../theme/presentation/bloc/theme_cubit.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../location/presentation/bloc/location_cubit.dart';
import '../../../location/presentation/bloc/location_state.dart';
import '../widgets/category_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCubit = context.watch<LanguageCubit>();
    final bool isHindi = languageCubit.state.locale.languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: InkWell(
          onTap: () => context.push('/map-picker'),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.45,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppConstants.accentGold,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        l10n.deliveryLocation,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppConstants.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 18,
                      color: AppConstants.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                BlocBuilder<LocationCubit, LocationState>(
                  builder: (context, state) {
                    String displayLocation = isHindi ? 'गोपालपुरा (जयपुर)' : 'Gopalpura (Jaipur)';
                    if (state is LocationSuccess && state.address != null) {
                      final addr = state.address!;
                      displayLocation = addr.village.isNotEmpty
                          ? '${addr.village}, ${addr.pincode}'
                          : addr.addressLine;
                    }
                    return Text(
                      displayLocation,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Account/Profile Icon
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoggedIn = state is Authenticated;
              return IconButton(
                icon: Icon(
                  isLoggedIn ? Icons.account_circle_rounded : Icons.account_circle_outlined,
                  color: AppConstants.primaryGreen,
                ),
                onPressed: () {
                  if (isLoggedIn) {
                    context.push('/profile');
                  } else {
                    context.push('/login');
                  }
                },
              );
            },
          ),
          // Theme Switch Action Icon
          IconButton(
            onPressed: () => _showThemeBottomSheet(context),
            icon: Icon(
              Icons.palette_outlined,
              color: AppConstants.primaryGreen,
            ),
          ),
          // Language Switch Action Chip
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                context
                    .read<LanguageCubit>()
                    .changeLanguage(isHindi ? 'en' : 'hi');
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.translate_rounded,
                      size: 14,
                      color: AppConstants.primaryGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isHindi ? 'English' : 'हिंदी',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Cart Action Icon
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final cartCount = state.cart.items.fold<int>(0, (sum, item) => sum + item.quantity);
              return IconButton(
                onPressed: () => context.push('/cart'),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AppConstants.primaryGreen,
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppConstants.accentGold,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Order History Action Icon
          IconButton(
            onPressed: () => context.push('/order-history'),
            icon: Icon(
              Icons.history_rounded,
              color: AppConstants.primaryGreen,
            ),
          ),
          // Admin Panel Toggle Icon
          IconButton(
            onPressed: () => context.push('/admin'),
            icon: Icon(
              Icons.admin_panel_settings_outlined,
              color: AppConstants.primaryGreen,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          color: AppConstants.primaryGreen,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Devotional Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppConstants.primaryGreen.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isHindi ? AppConstants.shivayaHi : AppConstants.shivayaEn,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppConstants.accentGold,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.tagline,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppConstants.primaryGreen,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),

                // Free Delivery Message Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.accentGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_shipping_rounded,
                        color: AppConstants.accentOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.freeDeliveryMsg,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppConstants.primaryGreenDark,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Premium Category Card Layout (Grid)
                Text(
                  isHindi ? 'मुख्य श्रेणियाँ' : 'Explore Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppConstants.primaryGreen,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.maxWidth;
                    int crossAxisCount = 2;
                    double aspectRatio = 0.85;
                    
                    if (width > 1000) {
                      crossAxisCount = 4;
                      aspectRatio = 1.1;
                    } else if (width > 600) {
                      crossAxisCount = 3;
                      aspectRatio = 0.95;
                    }
                    
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: aspectRatio,
                      children: [
                        CategoryCard(
                          titleEn: 'Cow',
                          titleHi: 'गाय',
                          imageUrl: AppConstants.imgCategoryCow,
                          onTap: () => context.push('/cows'),
                        ),
                        CategoryCard(
                          titleEn: 'Buffalo',
                          titleHi: 'भैंस',
                          imageUrl: AppConstants.imgCategoryBuffalo,
                          onTap: () => context.push('/buffalos'),
                        ),
                        CategoryCard(
                          titleEn: 'Other Products',
                          titleHi: 'अन्य उत्पाद',
                          imageUrl: AppConstants.imgCategoryOtherProducts,
                          onTap: () => context.push('/products'),
                        ),
                        CategoryCard(
                          titleEn: 'Bulk & Event Orders',
                          titleHi: 'थोक एवं समारोह ऑर्डर',
                          imageUrl: AppConstants.imgCategoryBulkOrders,
                          onTap: () => context.push('/bulk-orders'),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final themeCubit = context.read<ThemeCubit>();
    final currentTheme = themeCubit.state.themeType;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.backgroundCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'ऐप थीम चुनें' : 'Select App Theme',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppConstants.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  isHindi
                      ? 'अपनी पसंदीदा रंग योजना चुनें'
                      : 'Choose your preferred color palette',
                  style: TextStyle(
                    color: AppConstants.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
                _buildThemeOption(
                  context: context,
                  type: ThemeType.light,
                  title: isHindi ? 'लाइट थीम (प्राकृतिक)' : 'Light Theme (Natural)',
                  subtitle: isHindi ? 'सफेद, हरा और क्रीम रंग' : 'Cream background with deep green highlights',
                  color: const Color(0xFF1B4332),
                  isSelected: currentTheme == ThemeType.light,
                  onTap: () {
                    themeCubit.changeTheme(ThemeType.light);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildThemeOption(
                  context: context,
                  type: ThemeType.dark,
                  title: isHindi ? 'डार्क थीम (ब्लैक)' : 'Dark Theme (Black)',
                  subtitle: isHindi ? 'आरामदायक डार्क मोड' : 'Deep dark background with emerald accents',
                  color: const Color(0xFF52B788),
                  isSelected: currentTheme == ThemeType.dark,
                  onTap: () {
                    themeCubit.changeTheme(ThemeType.dark);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildThemeOption(
                  context: context,
                  type: ThemeType.gold,
                  title: isHindi ? 'गोल्ड थीम (शाही)' : 'Gold Theme (Royal)',
                  subtitle: isHindi ? 'सुनहरा और गेहूं रंग' : 'Luxurious wheat base with gold highlights',
                  color: const Color(0xFF8C6A15),
                  isSelected: currentTheme == ThemeType.gold,
                  onTap: () {
                    themeCubit.changeTheme(ThemeType.gold);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required ThemeType type,
    required String title,
    required String subtitle,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryGreen.withValues(alpha: 0.08)
              : AppConstants.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppConstants.primaryGreen : AppConstants.dividerColor,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lens,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? AppConstants.primaryGreen : AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppConstants.primaryGreen,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
