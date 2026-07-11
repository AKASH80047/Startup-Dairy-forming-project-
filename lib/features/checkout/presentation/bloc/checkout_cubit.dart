import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/order_entity.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final StorageService _storageService;

  CheckoutCubit(this._storageService) : super(CheckoutInitial());

  /// Submits order to mock server/database and triggers success state, saving to local history cache and Cloud Firestore.
  Future<void> placeOrder(OrderEntity order) async {
    emit(CheckoutLoading());

    try {
      // Simulate network request delay
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Save order and cache delivery address locally
      await _storageService.saveOrderToHistory(order);
      await _storageService.cacheAddress(order.address);

      // Save order to Firestore if authenticated (non-blocking background write)
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final orderJson = order.toJson();
          orderJson['userId'] = user.uid;
          
          // Save in background without await to prevent blocking checkout if network/rules hang
          FirebaseFirestore.instance.collection('orders').doc(order.id).set(orderJson).catchError((_) => null);
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('orders')
              .doc(order.id)
              .set(orderJson)
              .catchError((_) => null);
        }
      } catch (_) {
        // Safe fallback for testing environment where Firebase is uninitialized
      }
      
      emit(CheckoutSuccess(order));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  /// Resets state back to initial.
  void resetCheckout() {
    emit(CheckoutInitial());
  }
}
