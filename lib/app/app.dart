import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../core/constants/app_constants.dart';
import '../core/services/storage_service.dart';
import '../features/language/presentation/bloc/language_cubit.dart';
import '../features/breed/domain/repositories/breed_repository.dart';
import '../features/breed/presentation/bloc/breed_cubit.dart';
import '../features/product/domain/repositories/product_repository.dart';
import '../features/product/presentation/bloc/product_cubit.dart';
import '../features/cart/presentation/bloc/cart_cubit.dart';
import '../features/location/presentation/bloc/location_cubit.dart';
import '../features/location/presentation/bloc/lgd_cubit.dart';
import '../features/location/presentation/bloc/lgd_villages_cubit.dart';
import '../features/location/data/datasources/location_remote_data_source.dart';
import '../features/location/data/repositories/location_repository_impl.dart';
import '../features/location/domain/usecases/location_usecases.dart';
import '../features/location/presentation/bloc/administrative_location_bloc.dart';
import '../features/checkout/presentation/bloc/checkout_cubit.dart';
import '../features/bulk_order/presentation/bloc/bulk_order_cubit.dart';
import '../features/admin/presentation/bloc/admin_cubit.dart';
import '../features/theme/presentation/bloc/theme_cubit.dart';
import '../features/theme/presentation/bloc/theme_state.dart';
import '../features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dio/dio.dart';
import '../features/payment/data/datasources/payment_remote_data_source.dart';
import '../features/payment/data/repositories/payment_repository_impl.dart';
import '../features/payment/domain/usecases/create_payment.dart';
import '../features/payment/domain/usecases/get_payment_status.dart';
import '../features/payment/domain/usecases/verify_payment.dart';
import '../features/payment/presentation/bloc/payment_bloc.dart';
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
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(storageService),
          ),
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
          BlocProvider<LgdCubit>(
            create: (context) => LgdCubit(),
          ),
          BlocProvider<LgdVillagesCubit>(
            create: (context) => LgdVillagesCubit(),
          ),
          BlocProvider<AdministrativeLocationBloc>(
            create: (context) {
              final remoteDataSource = LocationRemoteDataSourceImpl();
              final repository = LocationRepositoryImpl(remoteDataSource);
              return AdministrativeLocationBloc(
                getStatesUseCase: GetStatesUseCase(repository),
                getDistrictsUseCase: GetDistrictsUseCase(repository),
                getSubDistrictsUseCase: GetSubDistrictsUseCase(repository),
                searchVillagesUseCase: SearchVillagesUseCase(repository),
              );
            },
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
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) {
              final dio = Dio(BaseOptions(baseUrl: 'https://api.pandeydairy.com/api'));
              final remoteDataSource = PaymentRemoteDataSourceImpl(dio: dio);
              final repository = PaymentRepositoryImpl(remoteDataSource: remoteDataSource);
              return PaymentBloc(
                createPaymentSession: CreatePaymentSession(repository),
                verifyPayment: VerifyPayment(repository),
                getPaymentStatus: GetPaymentStatus(repository),
              );
            },
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            // Update activeTheme global tracking
            AppConstants.activeTheme = themeState.themeType;

            return BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return MaterialApp.router(
                  title: 'Pandey Dairy Farming',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.getTheme(themeState.themeType),
                  routerConfig: AppRouter.router,
                  locale: state.locale,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  builder: (context, child) {
                    final mediaQuery = MediaQuery.of(context);
                    final width = mediaQuery.size.width;
                    if (width > 600) {
                      final theme = Theme.of(context);
                      final isDark = theme.brightness == Brightness.dark;
                      final Color outerBg = isDark
                          ? const Color(0xFF0C100E)
                          : const Color(0xFFE5DFD3);
                      
                      const double targetWidth = 500.0;
                      
                      return Scaffold(
                        backgroundColor: outerBg,
                        body: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: targetWidth),
                            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              border: Border.all(
                                color: theme.dividerColor,
                                width: 1.0,
                              ),
                            ),
                            child: MediaQuery(
                              data: mediaQuery.copyWith(
                                size: Size(targetWidth, mediaQuery.size.height - 48),
                              ),
                              child: child!,
                            ),
                          ),
                        ),
                      );
                    }
                    return child!;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
