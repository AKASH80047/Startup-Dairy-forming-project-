import 'package:flutter_test/flutter_test.dart';
import 'package:pandey/core/utils/distance_calculator.dart';
import 'package:pandey/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:pandey/features/cart/domain/entities/cart_item.dart';
import 'package:pandey/features/location/presentation/bloc/location_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pandey/core/services/storage_service.dart';
import 'package:pandey/features/checkout/presentation/bloc/checkout_cubit.dart';
import 'package:pandey/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:pandey/features/checkout/domain/entities/order_entity.dart';
import 'package:pandey/features/location/domain/entities/user_address.dart';

void main() {
  group('DistanceCalculator Tests', () {
    test('Calculate exact distance between Jaipur farm base and a point', () {
      final double distance = DistanceCalculator.calculateDistance(
        startLatitude: LocationCubit.farmLatitude,
        startLongitude: LocationCubit.farmLongitude,
        endLatitude: 26.8600, // Slightly north
        endLongitude: 75.7700, // Slightly east
      );

      // Verify calculation returns a valid positive distance
      expect(distance, greaterThan(0.0));
      expect(distance, lessThan(3.0));
    });
   group('CartCubit State Management Tests', () {
      late CartCubit cartCubit;

      setUp(() {
        cartCubit = CartCubit();
      });

      tearDown(() {
        cartCubit.close();
      });

      test('Cart starts empty', () {
        expect(cartCubit.state.cart.items.isEmpty, isTrue);
        expect(cartCubit.state.cart.subtotal, 0.0);
      });

      test('Add new CartItem to cart', () {
        const item = CartItem(
          id: 'test_product_1',
          productId: 'prod_1',
          nameEnglish: 'Paneer',
          nameHindi: 'पनीर',
          imageUrl: '',
          price: 150.0,
          unit: '500g',
          quantity: 1,
          isMilk: false,
        );

        cartCubit.addItem(item);

        expect(cartCubit.state.cart.items.length, 1);
        expect(cartCubit.state.cart.items.first.id, 'test_product_1');
        expect(cartCubit.state.cart.subtotal, 150.0);
      });

      test('Increment quantity if identical CartItem is added', () {
        const item = CartItem(
          id: 'test_product_1',
          productId: 'prod_1',
          nameEnglish: 'Paneer',
          nameHindi: 'पनीर',
          imageUrl: '',
          price: 150.0,
          unit: '500g',
          quantity: 1,
          isMilk: false,
        );

        cartCubit.addItem(item);
        cartCubit.addItem(item);

        expect(cartCubit.state.cart.items.length, 1);
        expect(cartCubit.state.cart.items.first.quantity, 2);
        expect(cartCubit.state.cart.subtotal, 300.0);
      });

      test('Update quantity and remove when quantity is 0', () {
        const item = CartItem(
          id: 'test_product_1',
          productId: 'prod_1',
          nameEnglish: 'Paneer',
          nameHindi: 'पनीर',
          imageUrl: '',
          price: 150.0,
          unit: '500g',
          quantity: 2,
          isMilk: false,
        );

        cartCubit.addItem(item);
        cartCubit.updateQuantity('test_product_1', 3);
        expect(cartCubit.state.cart.items.first.quantity, 3);

        cartCubit.updateQuantity('test_product_1', 0);
        expect(cartCubit.state.cart.items.isEmpty, isTrue);
      });

      test('Delivery fee slabs calculations based on distance', () {
        // Slab 1: 0 - 2 km (Free)
        cartCubit.updateDeliveryDistance(1.5);
        expect(cartCubit.state.cart.deliveryCharge, 0.0);

        // Slab 2: 2 - 5 km (₹20)
        cartCubit.updateDeliveryDistance(3.5);
        expect(cartCubit.state.cart.deliveryCharge, 20.0);

        // Slab 3: 5 - 10 km (₹40)
        cartCubit.updateDeliveryDistance(7.2);
        expect(cartCubit.state.cart.deliveryCharge, 40.0);

        // Slab 4: > 10 km (₹9999 / Unavailable)
        cartCubit.updateDeliveryDistance(12.5);
        expect(cartCubit.state.cart.deliveryCharge, 9999.0);
      });
    });

    group('CheckoutCubit Tests', () {
      late CheckoutCubit checkoutCubit;

      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        checkoutCubit = CheckoutCubit(StorageService(prefs));
      });

      tearDown(() {
        checkoutCubit.close();
      });

      test('Checkout starts in CheckoutInitial', () {
        expect(checkoutCubit.state, isA<CheckoutInitial>());
      });

      test('Place order completes and transitions to Success', () async {
        const address = UserAddress(
          latitude: 26.8530,
          longitude: 75.7681,
          addressLine: 'Gopalpura, Jaipur',
          village: 'Jaipur',
          pincode: '302015',
        );

        final order = OrderEntity(
          id: 'TEST-123',
          customerName: 'Kamlesh Pandey',
          customerPhone: '9876543210',
          address: address,
          deliverySlot: 'morning',
          paymentMethod: 'cod',
          items: const [],
          subtotal: 0.0,
          deliveryCharge: 0.0,
          grandTotal: 0.0,
          createdAt: DateTime.now(),
        );

        final Future<void> orderFuture = checkoutCubit.placeOrder(order);

        expect(checkoutCubit.state, isA<CheckoutLoading>());

        await orderFuture;

        expect(checkoutCubit.state, isA<CheckoutSuccess>());
        final successState = checkoutCubit.state as CheckoutSuccess;
        expect(successState.order.id, 'TEST-123');
        expect(successState.order.customerName, 'Kamlesh Pandey');
      });
    });
  });
}
