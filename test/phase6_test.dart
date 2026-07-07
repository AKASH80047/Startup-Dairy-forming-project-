import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pandey/core/services/storage_service.dart';
import 'package:pandey/features/bulk_order/presentation/bloc/bulk_order_cubit.dart';
import 'package:pandey/features/bulk_order/presentation/bloc/bulk_order_state.dart';
import 'package:pandey/features/bulk_order/domain/entities/bulk_order_entity.dart';
import 'package:pandey/features/bulk_order/domain/entities/bulk_order_item.dart';
import 'package:pandey/features/location/domain/entities/user_address.dart';

void main() {
  group('BulkOrder Dynamic Discount Slabs Tests', () {
    test('Subtotal below ₹2,000 gives 0% discount', () {
      expect(BulkOrderCubit.calculateDiscountPercentage(1500.0), 0.0);
      expect(BulkOrderCubit.calculateDiscount(1500.0), 0.0);
    });

    test('Subtotal ₹2,000 to ₹4,999 gives 2% discount', () {
      expect(BulkOrderCubit.calculateDiscountPercentage(2500.0), 0.02);
      expect(BulkOrderCubit.calculateDiscount(2500.0), 50.0);
    });

    test('Subtotal ₹5,000 to ₹9,999 gives 5% discount', () {
      expect(BulkOrderCubit.calculateDiscountPercentage(6000.0), 0.05);
      expect(BulkOrderCubit.calculateDiscount(6000.0), 300.0);
    });

    test('Subtotal ₹10,000 to ₹24,999 gives 8% discount', () {
      expect(BulkOrderCubit.calculateDiscountPercentage(15000.0), 0.08);
      expect(BulkOrderCubit.calculateDiscount(15000.0), 1200.0);
    });

    test('Subtotal ₹25,000 to ₹49,999 gives 10% discount', () {
      expect(BulkOrderCubit.calculateDiscountPercentage(30000.0), 0.10);
      expect(BulkOrderCubit.calculateDiscount(30000.0), 3000.0);
    });

    test('Subtotal ₹50,000+ gives 15% discount', () {
      expect(BulkOrderCubit.calculateDiscountPercentage(60000.0), 0.15);
      expect(BulkOrderCubit.calculateDiscount(60000.0), 9000.0);
    });
  });

  group('BulkOrder Calculations & Validation Tests', () {
    late BulkOrderCubit bulkOrderCubit;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      bulkOrderCubit = BulkOrderCubit(StorageService(prefs));
    });

    tearDown(() {
      bulkOrderCubit.close();
    });

    const testAddress = UserAddress(
      latitude: 26.8530,
      longitude: 75.7681,
      addressLine: 'Sodala, Jaipur',
      village: 'Jaipur',
      pincode: '302019',
    );

    const testItem = BulkOrderItem(
      productId: 'prod_buffalo_milk',
      nameEnglish: 'Pure Buffalo Milk',
      nameHindi: 'भैंस का दूध',
      price: 80.0,
      unit: 'L',
      quantity: 100.0, // Subtotal = ₹8000
    );

    test('Calculate minimum 20% advance payment requirement correctly', () {
      const double totalAmount = 10000.0;
      final double minAdvance = BulkOrderCubit.calculateMinAdvance(totalAmount);
      expect(minAdvance, 2000.0);
    });

    test('placeBulkOrder fails if advance payment is less than 20%', () async {
      // Subtotal = ₹8000. Discount 5% = ₹400. Total = ₹7600. Min Advance = ₹1520.
      final order = BulkOrderEntity(
        id: 'BULK-TEST-1',
        customerName: 'Karan Sharma',
        customerPhone: '9876543210',
        eventType: 'Wedding',
        eventDate: DateTime.now().add(const Duration(days: 5)),
        expectedGuests: 100,
        address: testAddress,
        items: const [testItem],
        subtotal: 8000.0,
        discountAmount: 400.0,
        deliveryCharge: 0.0,
        advancePaid: 1000.0, // Less than 1520 minimum advance
        pendingBalance: 6600.0,
        grandTotal: 7600.0,
        notes: 'Test low advance',
        paymentMethod: 'cash',
        status: 'Confirmed',
        createdAt: DateTime.now(),
      );

      await bulkOrderCubit.placeBulkOrder(order);

      expect(bulkOrderCubit.state, isA<BulkOrderError>());
      final errorState = bulkOrderCubit.state as BulkOrderError;
      expect(errorState.message, contains('Advance payment must be at least 20%'));
    });

    test('placeBulkOrder succeeds and persists locally when advance payment is >= 20%', () async {
      // Subtotal = ₹8000. Discount 5% = ₹400. Total = ₹7600. Min Advance = ₹1520.
      final order = BulkOrderEntity(
        id: 'BULK-TEST-2',
        customerName: 'Karan Sharma',
        customerPhone: '9876543210',
        eventType: 'Wedding',
        eventDate: DateTime.now().add(const Duration(days: 5)),
        expectedGuests: 100,
        address: testAddress,
        items: const [testItem],
        subtotal: 8000.0,
        discountAmount: 400.0,
        deliveryCharge: 0.0,
        advancePaid: 2000.0, // Valid advance (>= 1520)
        pendingBalance: 5600.0,
        grandTotal: 7600.0,
        notes: 'Test valid advance',
        paymentMethod: 'upi',
        status: 'Confirmed',
        createdAt: DateTime.now(),
      );

      await bulkOrderCubit.placeBulkOrder(order);

      expect(bulkOrderCubit.state, isA<BulkOrderSuccess>());
      final successState = bulkOrderCubit.state as BulkOrderSuccess;
      expect(successState.order.id, 'BULK-TEST-2');
      expect(successState.order.pendingBalance, 5600.0);
    });
  });
}
