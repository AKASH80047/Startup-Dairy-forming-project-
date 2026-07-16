import 'package:flutter/material.dart';
import '../enum/theme_type.dart';

class AppConstants {
  // Brand Names
  static const String appNameEn = 'Pandey Dairy Farming';
  static const String appNameHi = 'पांडेय डेयरी फार्मिंग';

  // Devotional Lines
  static const String shivayaEn = 'OM NAMAH SHIVAYA';
  static const String shivayaHi = 'ॐ नमः शिवाय';

  // Taglines
  static const String taglineEn = 'Pure • Fresh • From Our Roots';
  static const String taglineHi = 'शुद्ध • ताज़ा • अपनी मिट्टी से';

  // Storage Keys
  static const String keyLanguageCode = 'selected_language_code';

  // Active theme tracking
  static ThemeType activeTheme = ThemeType.light;

  // Colors - Premium Rural-Modern Palette (Dynamic depending on activeTheme)
  static Color get primaryGreen {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFF52B788); // Lighter emerald green for dark mode readability
      case ThemeType.gold:
        return const Color(0xFF8C6A15); // Luxurious deep gold
      case ThemeType.light:
        return const Color(0xFF1B4332); // Deep natural green
    }
  }

  static Color get primaryGreenDark {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFF1B4332);
      case ThemeType.gold:
        return const Color(0xFF5C4308);
      case ThemeType.light:
        return const Color(0xFF0F2D22);
    }
  }

  static Color get secondaryGreen {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFF74C69D);
      case ThemeType.gold:
        return const Color(0xFFB59449);
      case ThemeType.light:
        return const Color(0xFF40916C);
    }
  }

  static Color get accentGold {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFFF4D35E);
      case ThemeType.gold:
        return const Color(0xFFE5BA53);
      case ThemeType.light:
        return const Color(0xFFD4AF37);
    }
  }

  static Color get backgroundCream {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFF0F1412); // Pitch black/charcoal green for OLED contrast
      case ThemeType.gold:
        return const Color(0xFFFAF7F0); // Wheat/ivory background
      case ThemeType.light:
        return const Color(0xFFF9F6F0); // Warm cream background
    }
  }

  static Color get surfaceWhite {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFF1B221E); // Dark surface box
      case ThemeType.gold:
        return const Color(0xFFFFFDF9);
      case ThemeType.light:
        return const Color(0xFFFFFFFF);
    }
  }

  static Color get textPrimary {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFFE2EBE7); // High contrast text
      case ThemeType.gold:
        return const Color(0xFF2C2518);
      case ThemeType.light:
        return const Color(0xFF1A2621);
    }
  }

  static Color get textSecondary {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFF8B9E96);
      case ThemeType.gold:
        return const Color(0xFF70654D);
      case ThemeType.light:
        return const Color(0xFF52615B);
    }
  }

  static Color get dividerColor {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFF2D3A34);
      case ThemeType.gold:
        return const Color(0xFFE8E1CE);
      case ThemeType.light:
        return const Color(0xFFE2EBE7);
    }
  }

  static Color get accentOrange {
    switch (activeTheme) {
      case ThemeType.dark:
        return const Color(0xFFFF9F1C);
      case ThemeType.gold:
        return const Color(0xFFE76F51);
      case ThemeType.light:
        return const Color(0xFFD87D38);
    }
  }

  // Category High-Quality Images (Local Assets)
  static const String imgCategoryCow = 'assets/images/cat_cow.jpg';
  static const String imgCategoryBuffalo = 'assets/images/cat_buffalo.jpg';
  static const String imgCategoryOtherProducts = 'assets/images/cat_other_products.jpg';
  static const String imgCategoryBulkOrders = 'assets/images/cat_bulk_orders.jpg';
  static const String imgCategoryMilk = 'assets/images/banner_milk.jpg';
  static const String imgCategoryFodder = 'assets/images/cat_fodder.jpg';
  static const String imgCategoryOrganic = 'assets/images/cat_organic.jpg';
  static const String imgCategoryVeterinary = 'assets/images/cat_veterinary.jpg';
  static const String imgCategoryEquipment = 'assets/images/cat_equipment.jpg';
  static const String imgCategorySeeds = 'assets/images/cat_seeds.jpg';
  static const String imgCategoryTransport = 'assets/images/cat_transport.jpg';
  static const String imgCategorySchemes = 'assets/images/cat_schemes.jpg';
  static const String imgCategoryCommunity = 'assets/images/cat_community.jpg';
  static const String imgCategoryMyDairy = 'assets/images/cat_mydairy.jpg';
}
