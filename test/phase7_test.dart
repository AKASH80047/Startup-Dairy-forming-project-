import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pandey/core/services/storage_service.dart';
import 'package:pandey/features/admin/presentation/bloc/admin_cubit.dart';
import 'package:pandey/features/admin/presentation/bloc/admin_state.dart';
import 'package:pandey/features/admin/domain/entities/admin_village_entity.dart';
import 'package:pandey/features/admin/domain/entities/daily_milk_customer_entity.dart';
import 'package:pandey/features/checkout/domain/entities/order_entity.dart';
import 'package:pandey/features/location/presentation/bloc/location_cubit.dart';
import 'package:pandey/features/location/presentation/bloc/location_state.dart';
import 'package:pandey/features/location/domain/entities/user_address.dart';

void main() {
  group('Admin Dashboard & Management Tests', () {
    late AdminCubit adminCubit;
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService(prefs);
      adminCubit = AdminCubit(storageService);
    });

    tearDown(() {
      adminCubit.close();
    });

    test('Initializes with default mock villages pre-populated', () {
      expect(adminCubit.state, isA<AdminLoaded>());
      final state = adminCubit.state as AdminLoaded;
      expect(state.villages.length, 14);
      expect(state.villages.first.nameEnglish, 'Gopalpura');
    });

    test('Add village appends to local list', () async {
      const newVillage = AdminVillageEntity(
        id: 'v_malviya',
        nameEnglish: 'Malviya Nagar',
        nameHindi: 'मालवीय नगर',
        district: 'Jaipur',
        state: 'Rajasthan',
        pincode: '302017',
        isActive: true,
      );

      await adminCubit.addVillage(newVillage);

      expect(adminCubit.state, isA<AdminLoaded>());
      final state = adminCubit.state as AdminLoaded;
      expect(state.villages.length, 15);
      expect(state.villages.last.nameEnglish, 'Malviya Nagar');
    });

    test('Toggle village active status changes isActive parameter', () async {
      // First village (Gopalpura) is active (true). Let's toggle it.
      await adminCubit.toggleVillageStatus('v_gopalpura');

      final state = adminCubit.state as AdminLoaded;
      final gopalpura = state.villages.firstWhere((v) => v.id == 'v_gopalpura');
      expect(gopalpura.isActive, false);
    });

    test('Register daily customer appends to subscribers database list', () async {
      final customer = DailyMilkCustomerEntity(
        id: 'c_test_1',
        name: 'Rajesh Sharma',
        phone: '9876543210',
        village: 'Gopalpura',
        address: '12 Main Rd',
        morningQty: 2.0,
        eveningQty: 1.0,
        pricePerLitre: 80.0,
        startDate: DateTime.now(),
        status: 'Active',
        animalType: 'Buffalo',
        paymentCycle: 'Monthly',
      );

      await adminCubit.registerDailyCustomer(customer);

      final state = adminCubit.state as AdminLoaded;
      expect(state.dailyCustomers.length, 1);
      expect(state.dailyCustomers.first.name, 'Rajesh Sharma');
    });

    test('Admin changeOrderStatus updates order status in storage', () async {
      final order = OrderEntity(
        id: 'ORDER-101',
        customerName: 'Aman Verma',
        customerPhone: '9000000000',
        address: const UserAddress(
          latitude: 26.8530,
          longitude: 75.7681,
          addressLine: 'Jaipur',
          village: 'Jaipur',
          pincode: '302015',
        ),
        deliverySlot: 'morning',
        paymentMethod: 'cod',
        items: const [],
        subtotal: 500.0,
        deliveryCharge: 0.0,
        grandTotal: 500.0,
        createdAt: DateTime.now(),
        status: 'Pending',
      );

      await storageService.saveOrderToHistory(order);

      await adminCubit.changeOrderStatus('ORDER-101', 'Delivered');

      final cachedOrders = storageService.getOrderHistory();
      expect(cachedOrders.first.status, 'Delivered');
    });
  });

  group('Location manual entry fallback tests', () {
    test('LocationCubit setManualAddress emits LocationSuccess with correct distance', () async {
      final prefs = await SharedPreferences.getInstance();
      final storage = StorageService(prefs);
      final cubit = LocationCubit(storage);

      const address = UserAddress(
        latitude: LocationCubit.farmLatitude,
        longitude: LocationCubit.farmLongitude,
        addressLine: '123 Gopalpura Lane',
        village: 'Gopalpura',
        pincode: '302015',
      );

      cubit.setManualAddress(address);

      expect(cubit.state, isA<LocationSuccess>());
      final success = cubit.state as LocationSuccess;
      expect(success.distanceKm, 0.0);
      expect(success.address?.addressLine, '123 Gopalpura Lane');
      cubit.close();
    });
  });
}
