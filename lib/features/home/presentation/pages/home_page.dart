import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enum/theme_type.dart';
import '../../../language/presentation/bloc/language_cubit.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../theme/presentation/bloc/theme_cubit.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../location/presentation/bloc/location_cubit.dart';
import '../../../location/presentation/bloc/location_state.dart';
import '../widgets/category_card.dart';
import '../../../../core/utils/web_image_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCubit = context.watch<LanguageCubit>();
    final bool isHindi = languageCubit.state.locale.languageCode == 'hi';

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    final List<Map<String, dynamic>> categories = [
      {
        'titleEn': 'Milk',
        'titleHi': 'दूध',
        'image': AppConstants.imgCategoryMilk,
        'onTap': () => _showMilkChoiceBottomSheet(context, isHindi),
      },
      {
        'titleEn': 'Fodder Market',
        'titleHi': 'चारा बाजार',
        'image': AppConstants.imgCategoryFodder,
        'onTap': () => context.push('/fodder'),
      },
      {
        'titleEn': 'Buy & Sell Animals',
        'titleHi': 'पशु खरीदें और बेचें',
        'image': AppConstants.imgCategoryCow,
        'onTap': () => context.push('/buy-sell-animals'),
      },
      {
        'titleEn': 'Organic Products',
        'titleHi': 'जैविक उत्पाद',
        'image': AppConstants.imgCategoryOrganic,
        'onTap': () => context.push('/organic'),
      },
      {
        'titleEn': 'Veterinary',
        'titleHi': 'पशु चिकित्सक',
        'image': AppConstants.imgCategoryVeterinary,
        'onTap': () => context.push('/veterinary'),
      },
      {
        'titleEn': 'Dairy Products',
        'titleHi': 'डेयरी उत्पाद',
        'image': AppConstants.imgCategoryOtherProducts,
        'onTap': () => context.push('/products'),
      },
      {
        'titleEn': 'Farm Equipment',
        'titleHi': 'कृषि उपकरण',
        'image': AppConstants.imgCategoryEquipment,
        'onTap': () => context.push('/equipment'),
      },
      {
        'titleEn': 'Seeds & Feed',
        'titleHi': 'बीज और चारा',
        'image': AppConstants.imgCategorySeeds,
        'onTap': () => context.push('/seeds-feed'),
      },
      {
        'titleEn': 'Transport',
        'titleHi': 'परिवहन',
        'image': AppConstants.imgCategoryTransport,
        'onTap': () => context.push('/transport'),
      },
      {
        'titleEn': 'Government Schemes',
        'titleHi': 'सरकारी योजनाएं',
        'image': AppConstants.imgCategorySchemes,
        'onTap': () => context.push('/schemes'),
      },
      {
        'titleEn': 'Farmer Community',
        'titleHi': 'किसान समुदाय',
        'image': AppConstants.imgCategoryCommunity,
        'onTap': () => context.push('/community'),
      },
      {
        'titleEn': 'My Dairy',
        'titleHi': 'मेरी डेयरी',
        'image': AppConstants.imgCategoryMyDairy,
        'onTap': () => context.push('/my-dairy'),
      },
      {
        'titleEn': 'Admin Panel',
        'titleHi': 'एडमिन पैनल',
        'image': AppConstants.imgCategoryOtherProducts,
        'onTap': () => context.push('/admin'),
      },
    ];

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppConstants.backgroundCream,
        appBar: const DesktopHeader(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: _buildHomePageBody(context, true, isHindi, l10n, categories),
                  ),
                ),
              ),
              const DesktopFooter(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        backgroundColor: AppConstants.surfaceWhite,
        elevation: 0.5,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 36,
              errorBuilder: (context, error, stackTrace) => Text(
                isHindi ? '🕉️ पांडेय डेयरी' : '🕉️ Pandey Dairy',
                style: TextStyle(
                  color: AppConstants.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Language Toggle Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: InkWell(
              onTap: () {
                final newCode = isHindi ? 'en' : 'hi';
                context.read<LanguageCubit>().changeLanguage(newCode);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstants.primaryGreen.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(16),
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
            child: _buildHomePageBody(context, false, isHindi, l10n, categories),
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

  Widget _buildCategoryGrid({
    required List<Map<String, dynamic>> categories,
    required int crossAxisCount,
    required double aspectRatio,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        return CategoryCard(
          titleEn: cat['titleEn']!,
          titleHi: cat['titleHi']!,
          imageUrl: cat['image']!,
          onTap: cat['onTap']!,
        );
      },
    );
  }

  void _showMilkChoiceBottomSheet(BuildContext context, bool isHindi) {
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
                  isHindi ? 'दूध का चयन करें' : 'Select Milk Type',
                  style: TextStyle(
                    color: AppConstants.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isHindi
                      ? 'दूध ऑर्डर करने या सदस्यता के लिए नस्लें देखें'
                      : 'Browse breeds for milk ordering or subscription',
                  style: TextStyle(
                    color: AppConstants.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🐄', style: TextStyle(fontSize: 20)),
                  ),
                  title: Text(
                    isHindi ? 'गाय का दूध' : 'Cow Milk',
                    style: TextStyle(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    isHindi ? 'गीर, साहिवाल, थारपारकर आदि नस्लें' : 'Gir, Sahiwal, Tharparkar breeds',
                    style: TextStyle(color: AppConstants.textSecondary, fontSize: 11),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/cows');
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🐃', style: TextStyle(fontSize: 20)),
                  ),
                  title: Text(
                    isHindi ? 'भैंस का दूध' : 'Buffalo Milk',
                    style: TextStyle(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    isHindi ? 'मुर्राह, मेहसाणा, जाफराबादी आदि नस्लें' : 'Murrah, Mehsana, Jaffarabadi breeds',
                    style: TextStyle(color: AppConstants.textSecondary, fontSize: 11),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/buffalos');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePageBody(
    BuildContext context,
    bool isDesktop,
    bool isHindi,
    AppLocalizations l10n,
    List<Map<String, dynamic>> categories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Flipkart/Amazon Search Bar
        GestureDetector(
          onTap: () => context.push('/products'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppConstants.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppConstants.dividerColor, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: AppConstants.textSecondary, size: 20),
                const SizedBox(width: 12),
                Text(
                  isHindi ? 'मक्खन, घी, दूध या चारा खोजें...' : 'Search butter, ghee, milk, or fodder...',
                  style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Hero Banners (Slider Carousel)
        const HomeHeroBanner(),
        const SizedBox(height: 24),

        // Shop by Category quick links
        Text(
          isHindi ? 'कैटेगरी के अनुसार खरीदें' : 'Shop By Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppConstants.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildCircularCategoryRow(context, isHindi),
        const SizedBox(height: 24),

        // Deals of the day
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isHindi ? 'आज के धमाकेदार ऑफर्स' : 'Deals of the Day',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppConstants.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => context.push('/products'),
              child: Text(
                isHindi ? 'सभी देखें' : 'View All',
                style: TextStyle(color: AppConstants.accentGold, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        _buildDealsRow(context, isHindi),
        const SizedBox(height: 16),

        // Devotional / branding banner
        _buildDevotionalBanner(context, isHindi, l10n),
        const SizedBox(height: 24),

        // Ecosystem Categories Grid
        Text(
          isHindi ? 'डेयरी इकोसिस्टम और सेवाएं' : 'Our Complete Ecosystem',
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
              crossAxisCount = 5;
              aspectRatio = 1.0;
            } else if (width > 600) {
              crossAxisCount = 3;
              aspectRatio = 0.95;
            }

            return _buildCategoryGrid(
              categories: categories,
              crossAxisCount: crossAxisCount,
              aspectRatio: aspectRatio,
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCircularCategoryRow(BuildContext context, bool isHindi) {
    final List<Map<String, dynamic>> circularCats = [
      {
        'titleEn': 'Cow Milk',
        'titleHi': 'गाय का दूध',
        'icon': '🐄',
        'route': '/cows',
      },
      {
        'titleEn': 'Buffalo Milk',
        'titleHi': 'भैंस का दूध',
        'icon': '🐃',
        'route': '/buffalos',
      },
      {
        'titleEn': 'Pure Ghee',
        'titleHi': 'शुद्ध घी',
        'icon': '🍯',
        'route': '/products',
      },
      {
        'titleEn': 'Fresh Paneer',
        'titleHi': 'ताजा पनीर',
        'icon': '🧀',
        'route': '/products',
      },
      {
        'titleEn': 'Fodder Market',
        'titleHi': 'चारा बाजार',
        'icon': '🌾',
        'route': '/fodder',
      },
      {
        'titleEn': 'Doctors Hub',
        'titleHi': 'डॉक्टर',
        'icon': '🩺',
        'route': '/veterinary',
      },
      {
        'titleEn': 'Equipment',
        'titleHi': 'कृषि उपकरण',
        'icon': '🚜',
        'route': '/equipment',
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: circularCats.length,
        itemBuilder: (context, index) {
          final item = circularCats[index];
          final String label = isHindi ? item['titleHi'] : item['titleEn'];
          return Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: () => context.push(item['route']),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryGreen.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppConstants.primaryGreen.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item['icon'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppConstants.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDealsRow(BuildContext context, bool isHindi) {
    final List<Map<String, dynamic>> deals = [
      {
        'id': 'prod_ghee_gir',
        'titleEn': 'Gir Cow A2 Ghee',
        'titleHi': 'गीर गाय A2 घी',
        'price': 950.0,
        'originalPrice': 1100.0,
        'unit': '500 ml',
        'discount': '14% OFF',
        'image': 'assets/images/ghee_bowl.jpg',
        'rating': '4.9 ★',
      },
      {
        'id': 'prod_paneer_sahiwal',
        'titleEn': 'Fresh Sahiwal Paneer',
        'titleHi': 'ताजा साहिवाल पनीर',
        'price': 120.0,
        'originalPrice': 150.0,
        'unit': '250 gm',
        'discount': '20% OFF',
        'image': 'assets/images/paneer_block.jpg',
        'rating': '4.8 ★',
      },
      {
        'id': 'prod_milk_murrah',
        'titleEn': 'Murrah Buffalo A2 Milk',
        'titleHi': 'मुर्राह भैंस A2 दूध',
        'price': 80.0,
        'originalPrice': 90.0,
        'unit': '1 Litre',
        'discount': '11% OFF',
        'image': 'assets/images/milk_jug.jpg',
        'rating': '4.9 ★',
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: deals.length,
        itemBuilder: (context, index) {
          final item = deals[index];
          final String title = isHindi ? item['titleHi'] : item['titleEn'];
          final String unit = item['unit'];
          final String discount = item['discount'];
          final String rating = item['rating'];
          final double price = item['price'];
          final double originalPrice = item['originalPrice'];

          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 16, bottom: 8),
            decoration: BoxDecoration(
              color: AppConstants.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppConstants.dividerColor, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppImage(
                          path: item['image'],
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              discount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: AppConstants.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            unit,
                            style: TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: 9,
                            ),
                          ),
                          const Spacer(),
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
                                    '₹${price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: AppConstants.primaryGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  final cartItem = CartItem(
                                    id: '${item['id']}_deal',
                                    productId: item['id'],
                                    nameEnglish: item['titleEn'],
                                    nameHindi: item['titleHi'],
                                    imageUrl: item['image'],
                                    price: price,
                                    unit: unit,
                                    quantity: 1,
                                    isMilk: false,
                                  );
                                  context.read<CartCubit>().addItem(cartItem);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isHindi ? 'कार्ट में जोड़ा गया' : 'Added to Cart',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 14,
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
        },
      ),
    );
  }

  Widget _buildDevotionalBanner(BuildContext context, bool isHindi, AppLocalizations l10n) {
    return Container(
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
    );
  }
}

class DesktopHeader extends StatelessWidget implements PreferredSizeWidget {
  const DesktopHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCubit = context.watch<LanguageCubit>();
    final bool isHindi = languageCubit.state.locale.languageCode == 'hi';

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        border: Border(
          bottom: BorderSide(
            color: AppConstants.dividerColor,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.storefront_rounded,
                color: AppConstants.primaryGreen,
                size: 32,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isHindi ? AppConstants.appNameHi : AppConstants.appNameEn,
                    style: TextStyle(
                      color: AppConstants.primaryGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isHindi ? AppConstants.shivayaHi : AppConstants.shivayaEn,
                    style: TextStyle(
                      color: AppConstants.accentGold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderLink(context, isHindi ? 'गाय' : 'Cows', '/cows'),
              _buildHeaderLink(context, isHindi ? 'भैंस' : 'Buffalos', '/buffalos'),
              _buildHeaderLink(context, isHindi ? 'उत्पाद' : 'Products', '/products'),
              _buildHeaderLink(context, isHindi ? 'थोक बुकिंग' : 'Bulk Booking', '/bulk-orders'),
            ],
          ),
          InkWell(
            onTap: () => context.push('/map-picker'),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.backgroundCream,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppConstants.dividerColor, width: 0.5),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: AppConstants.accentGold,
                  ),
                  const SizedBox(width: 8),
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
                        style: TextStyle(
                          color: AppConstants.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  context.read<LanguageCubit>().changeLanguage(isHindi ? 'en' : 'hi');
                },
                icon: Icon(Icons.translate, size: 18, color: AppConstants.primaryGreen),
                label: Text(
                  isHindi ? 'English' : 'हिंदी',
                  style: TextStyle(color: AppConstants.primaryGreen, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.palette_outlined, color: AppConstants.primaryGreen),
                onPressed: () => _showThemeDialog(context),
              ),
              const SizedBox(width: 8),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoggedIn = state is Authenticated;
                  return IconButton(
                    icon: Icon(
                      isLoggedIn ? Icons.account_circle : Icons.account_circle_outlined,
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
              const SizedBox(width: 8),
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  final cartCount = state.cart.items.fold<int>(0, (sum, item) => sum + item.quantity);
                  return InkWell(
                    onTap: () => context.push('/cart'),
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart_outlined, color: AppConstants.primaryGreen),
                          onPressed: null,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppConstants.accentGold,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$cartCount',
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.history_rounded, color: AppConstants.primaryGreen),
                onPressed: () => context.push('/order-history'),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.admin_panel_settings_outlined, color: AppConstants.primaryGreen),
                onPressed: () => context.push('/admin'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLink(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () => context.push(route),
        child: Text(
          title,
          style: TextStyle(
            color: AppConstants.primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final themeCubit = context.read<ThemeCubit>();
        final currentTheme = themeCubit.state.themeType;
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light'),
                leading: Radio<ThemeType>(
                  value: ThemeType.light,
                  groupValue: currentTheme,
                  onChanged: (v) {
                    themeCubit.changeTheme(ThemeType.light);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Dark'),
                leading: Radio<ThemeType>(
                  value: ThemeType.dark,
                  groupValue: currentTheme,
                  onChanged: (v) {
                    themeCubit.changeTheme(ThemeType.dark);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Royal Gold'),
                leading: Radio<ThemeType>(
                  value: ThemeType.gold,
                  groupValue: currentTheme,
                  onChanged: (v) {
                    themeCubit.changeTheme(ThemeType.gold);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DesktopFooter extends StatelessWidget {
  const DesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';
    return Container(
      color: AppConstants.primaryGreenDark,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storefront_rounded, color: AppConstants.accentGold, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          isHindi ? AppConstants.appNameHi : AppConstants.appNameEn,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isHindi ? AppConstants.shivayaHi : AppConstants.shivayaEn,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isHindi
                          ? 'हम आपको और आपके परिवार को सीधे हमारे फार्म से ताजा, प्राकृतिक और शुद्ध दूध उत्पाद पहुंचाने के लिए प्रतिबद्ध हैं।'
                          : 'We are committed to delivering fresh, natural, and pure dairy products directly from our farms to your family.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'त्वरित लिंक्स' : 'Quick Links',
                      style: TextStyle(color: AppConstants.accentGold, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    _buildFooterLink(context, isHindi ? 'गाय का दूध' : 'Cow Milk Products', '/cows'),
                    _buildFooterLink(context, isHindi ? 'भैंस का दूध' : 'Buffalo Milk Products', '/buffalos'),
                    _buildFooterLink(context, isHindi ? 'अन्य उत्पाद' : 'Other Dairy Products', '/products'),
                    _buildFooterLink(context, isHindi ? 'थोक बुकिंग' : 'Bulk Event Orders', '/bulk-orders'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'सहायता एवं संपर्क' : 'Contact & Support',
                      style: TextStyle(color: AppConstants.accentGold, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    _buildFooterInfo(Icons.phone, '+91 99189 26054'),
                    _buildFooterInfo(Icons.email, 'support@pandeydairy.com'),
                    _buildFooterInfo(Icons.location_on, isHindi ? 'जयपुर, राजस्थान' : 'Jaipur, Rajasthan, India'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 Pandey Dairy Farming. All rights reserved.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
              ),
              Row(
                children: [
                  Icon(Icons.payment, color: Colors.white.withValues(alpha: 0.5), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isHindi ? 'सुरक्षित भुगतान (UPI/Paytm)' : 'Secure Payments via UPI & Paytm',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: () => context.push(route),
        child: Text(
          text,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildFooterInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeHeroBanner extends StatefulWidget {
  const HomeHeroBanner({super.key});

  @override
  State<HomeHeroBanner> createState() => _HomeHeroBannerState();
}

class _HomeHeroBannerState extends State<HomeHeroBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      _currentPage = (_currentPage + 1) % 3;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
      return true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final List<Map<String, String>> slides = [
      {
        'titleEn': 'Pure Cow & Buffalo Milk',
        'titleHi': 'शुद्ध गाय और भैंस का दूध',
        'subtitleEn': 'Freshly sourced dairy products delivered daily directly to your doorstep.',
        'subtitleHi': 'ताजा और पोषक डेयरी उत्पाद रोजाना सीधे आपके घर तक पहुंचाए जाते हैं।',
        'image': 'assets/images/banner_milk.jpg',
        'btnEn': 'Explore Breeds',
        'btnHi': 'नस्लें देखें',
        'route': '/cows',
      },
      {
        'titleEn': 'Organic Ghee & Paneer',
        'titleHi': 'ऑर्गेनिक घी और पनीर',
        'subtitleEn': 'Made using traditional hand-churned methods for authentic rural flavor.',
        'subtitleHi': 'पारंपरिक वैदिक मथानी विधि से तैयार, असली ग्रामीण स्वाद और खुशबू।',
        'image': 'assets/images/banner_ghee.jpg',
        'btnEn': 'Shop Products',
        'btnHi': 'उत्पाद खरीदें',
        'route': '/products',
      },
      {
        'titleEn': 'Bulk & Festival Bookings',
        'titleHi': 'थोक एवं समारोह बुकिंग',
        'subtitleEn': 'Need milk in bulk for events? Get special pricing and timely delivery.',
        'subtitleHi': 'शादी, त्योहारों या विशेष अवसरों के लिए थोक में दूध ऑर्डर करें। विशेष छूट पाएं।',
        'image': 'assets/images/banner_bulk.jpg',
        'btnEn': 'Book Event Order',
        'btnHi': 'थोक ऑर्डर करें',
        'route': '/bulk-orders',
      }
    ];

    return Container(
      height: 320,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    path: slide['image']!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isHindi ? slide['titleHi']! : slide['titleEn']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isHindi ? slide['subtitleHi']! : slide['subtitleEn']!,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.accentGold,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => context.push(slide['route']!),
                              child: Text(
                                isHindi ? slide['btnHi']! : slide['btnEn']!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 48,
            child: Row(
              children: List.generate(slides.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppConstants.accentGold : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
