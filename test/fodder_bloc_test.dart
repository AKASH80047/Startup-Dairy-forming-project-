import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pandey/features/fodder/data/repositories/fodder_repository_impl.dart';
import 'package:pandey/features/fodder/domain/usecases/get_fodder_items_usecase.dart';
import 'package:pandey/features/fodder/domain/usecases/upload_fodder_item_usecase.dart';
import 'package:pandey/features/fodder/presentation/bloc/fodder_cubit.dart';
import 'package:pandey/features/fodder/presentation/bloc/fodder_state.dart';
import 'package:pandey/features/fodder/domain/entities/fodder_item_entity.dart';

void main() {
  group('FodderCubit Marketplace Tests', () {
    late FodderCubit fodderCubit;
    late FodderRepositoryImpl repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repository = FodderRepositoryImpl(sharedPreferences: prefs);
      fodderCubit = FodderCubit(
        getFodderItemsUseCase: GetFodderItemsUseCase(repository),
        uploadFodderItemUseCase: UploadFodderItemUseCase(repository),
      );
    });

    tearDown(() {
      fodderCubit.close();
    });

    test('Initial state is FodderInitial', () {
      expect(fodderCubit.state, isA<FodderInitial>());
    });

    test('fetchFodderItems loads default prepopulated fodder listings', () async {
      final Future<void> fetchFuture = fodderCubit.fetchFodderItems();

      // Should emit loading first
      expect(fodderCubit.state, isA<FodderLoading>());

      await fetchFuture;

      expect(fodderCubit.state, isA<FodderLoaded>());
      final loaded = fodderCubit.state as FodderLoaded;
      expect(loaded.items.length, 4);
      expect(loaded.items.first.titleEn, 'Fresh Wheat Straw (Bhusa)');
    });

    test('uploadFodder adds listing and updates listings list', () async {
      final newFodder = FodderItemEntity(
        id: 'user_fodder_test',
        titleEn: 'Green Berseem Grass',
        titleHi: 'हरी बरसीम घास',
        categoryEn: 'Berseem',
        categoryHi: 'बरसीम',
        imageUrl: 'assets/images/cat_fodder.jpg',
        price: 300.0,
        unitEn: 'Quintal',
        unitHi: 'क्विंटल',
        quantity: 10.0,
        sellerName: 'Kamal Pandey',
        sellerPhone: '9000012345',
        village: 'Gopalpura',
        district: 'Jaipur',
        state: 'Rajasthan',
        deliveryAvailable: true,
        createdAt: DateTime.now(),
      );

      // Perform upload
      await fodderCubit.uploadFodder(newFodder);

      // Check final state has 5 items and contains the uploaded item first
      expect(fodderCubit.state, isA<FodderLoaded>());
      final loaded = fodderCubit.state as FodderLoaded;
      expect(loaded.items.length, 5);
      expect(loaded.items.first.id, 'user_fodder_test');
    });
  });
}
