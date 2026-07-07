import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/order_entity.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final StorageService _storageService;

  CheckoutCubit(this._storageService) : super(CheckoutInitial());

  /// Submits order to mock server/database and triggers success state, saving to local history cache.
  Future<void> placeOrder(OrderEntity order) async {
    emit(CheckoutLoading());

    try {
      // Simulate network request delay
      await Future.delayed(const Duration(milliseconds: 1200));
      
      // Save order and cache delivery address locally
      await _storageService.saveOrderToHistory(order);
      await _storageService.cacheAddress(order.address);
      
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
