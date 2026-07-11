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
import '../../features/location/presentation/pages/lgd_states_page.dart';
import '../../features/location/presentation/pages/lgd_villages_page.dart';
import '../../features/location/presentation/pages/select_location_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/checkout/presentation/pages/order_success_page.dart';
import '../../features/checkout/presentation/pages/order_history_page.dart';
import '../../features/checkout/domain/entities/order_entity.dart';
import '../../features/bulk_order/presentation/pages/bulk_order_form_page.dart';
import '../../features/bulk_order/presentation/pages/bulk_order_success_page.dart';
import '../../features/bulk_order/domain/entities/bulk_order_entity.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/checkout/presentation/pages/mock_gateway_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/payment/presentation/pages/payment_method_page.dart';
import '../../features/payment/presentation/pages/payment_processing_page.dart';
import '../../features/payment/presentation/pages/payment_success_page.dart';
import '../../features/payment/presentation/pages/payment_pending_page.dart';
import '../../features/payment/presentation/pages/payment_failed_page.dart';
import '../../features/payment/domain/entities/payment_session.dart';

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
      GoRoute(
        path: '/mock-gateway',
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return MockGatewayPage(order: order);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/payment-method',
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return PaymentMethodPage(order: order);
        },
      ),
      GoRoute(
        path: '/payment-processing',
        builder: (context, state) {
          final extra = state.extra as Map<String, Object?>;
          final order = extra['order'] as OrderEntity;
          final method = extra['method'] as String;
          final utr = extra['utr'] as String?;
          final session = extra['session'] as PaymentSession?;
          return PaymentProcessingPage(
            order: order,
            method: method,
            utr: utr,
            session: session,
          );
        },
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return PaymentSuccessPage(order: order);
        },
      ),
      GoRoute(
        path: '/payment-pending',
        builder: (context, state) {
          final extra = state.extra as Map<String, Object?>;
          final order = extra['order'] as OrderEntity;
          final utr = extra['utr'] as String?;
          return PaymentPendingPage(
            order: order,
            utr: utr,
          );
        },
      ),
      GoRoute(
        path: '/payment-failed',
        builder: (context, state) {
          final extra = state.extra as Map<String, Object?>;
          final order = extra['order'] as OrderEntity;
          final message = extra['message'] as String;
          return PaymentFailedPage(
            order: order,
            message: message,
          );
        },
      ),
      GoRoute(
        path: '/lgd-states',
        builder: (context, state) => const LgdStatesPage(),
      ),
      GoRoute(
        path: '/lgd-villages',
        builder: (context, state) => const LgdVillagesPage(),
      ),
      GoRoute(
        path: '/select-location',
        builder: (context, state) => const SelectLocationPage(),
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
                  color: AppConstants.primaryGreen.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
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
