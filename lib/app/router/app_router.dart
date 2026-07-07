import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/language/presentation/pages/language_selection_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../core/enum/animal_type.dart';
import '../../features/breed/presentation/pages/breed_list_page.dart';
import '../../features/breed/presentation/pages/breed_detail_page.dart';
import '../../features/product/presentation/pages/product_list_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/location/presentation/pages/map_picker_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/checkout/presentation/pages/order_success_page.dart';
import '../../features/checkout/presentation/pages/order_history_page.dart';
import '../../features/checkout/domain/entities/order_entity.dart';
import '../../features/bulk_order/presentation/pages/bulk_order_form_page.dart';
import '../../features/bulk_order/presentation/pages/bulk_order_success_page.dart';
import '../../features/bulk_order/domain/entities/bulk_order_entity.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSelectionPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/cows',
        builder: (context, state) => const BreedListPage(
          animalType: AnimalType.cow,
        ),
      ),
      GoRoute(
        path: '/buffalos',
        builder: (context, state) => const BreedListPage(
          animalType: AnimalType.buffalo,
        ),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListPage(),
      ),
      GoRoute(
        path: '/breed-detail/:id',
        builder: (context, state) {
          final breedId = state.pathParameters['id']!;
          return BreedDetailPage(breedId: breedId);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/map-picker',
        builder: (context, state) => const MapPickerPage(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/order-success',
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return OrderSuccessPage(order: order);
        },
      ),
      GoRoute(
        path: '/order-history',
        builder: (context, state) => const OrderHistoryPage(),
      ),
      GoRoute(
        path: '/bulk-orders',
        builder: (context, state) => const BulkOrderFormPage(),
      ),
      GoRoute(
        path: '/bulk-order-success',
        builder: (context, state) {
          final order = state.extra as BulkOrderEntity;
          return BulkOrderSuccessPage(order: order);
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardPage(),
      ),
    ],
  );
}

/// A clean placeholder screen for features that will be fully developed in subsequent phases.
class PlaceholderScreen extends StatelessWidget {
  final String titleEn;
  final String titleHi;

  const PlaceholderScreen({
    super.key,
    required this.titleEn,
    required this.titleHi,
  });

  @override
  Widget build(BuildContext context) {
    // Basic local check for language since AppLocalizations might not apply to placeholder title parameters directly.
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final String displayTitle = isHindi ? titleHi : titleEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  size: 64,
                  color: AppConstants.primaryGreen,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isHindi ? 'जल्द ही आ रहा है' : 'Coming Soon',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isHindi
                    ? 'यह फीचर विकास के अगले चरण में उपलब्ध होगा।'
                    : 'This feature will be fully functional in the next phase of development.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(isHindi ? 'वापस जाएं' : 'Go Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
