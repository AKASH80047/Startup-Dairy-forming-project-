import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../core/services/storage_service.dart';
import '../features/language/presentation/bloc/language_cubit.dart';
import '../features/breed/domain/repositories/breed_repository.dart';
import '../features/breed/presentation/bloc/breed_cubit.dart';
import '../features/product/domain/repositories/product_repository.dart';
import '../features/product/presentation/bloc/product_cubit.dart';
import '../features/cart/presentation/bloc/cart_cubit.dart';
import '../features/location/presentation/bloc/location_cubit.dart';
import '../features/checkout/presentation/bloc/checkout_cubit.dart';
import '../features/bulk_order/presentation/bloc/bulk_order_cubit.dart';
import '../features/admin/presentation/bloc/admin_cubit.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PandeyApp extends StatelessWidget {
  final StorageService storageService;
  final BreedRepository breedRepository;
  final ProductRepository productRepository;

  const PandeyApp({
    super.key,
    required this.storageService,
    required this.breedRepository,
    required this.productRepository,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<StorageService>.value(
      value: storageService,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(storageService),
          ),
          BlocProvider<BreedCubit>(
            create: (context) => BreedCubit(breedRepository),
          ),
          BlocProvider<ProductCubit>(
            create: (context) => ProductCubit(productRepository),
          ),
          BlocProvider<CartCubit>(
            create: (context) => CartCubit(),
          ),
          BlocProvider<LocationCubit>(
            create: (context) => LocationCubit(storageService),
          ),
          BlocProvider<CheckoutCubit>(
            create: (context) => CheckoutCubit(storageService),
          ),
          BlocProvider<BulkOrderCubit>(
            create: (context) => BulkOrderCubit(storageService),
          ),
          BlocProvider<AdminCubit>(
            create: (context) => AdminCubit(storageService),
          ),
        ],
        child: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Pandey Dairy Farming',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: AppRouter.router,
              locale: state.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );
  }
}
