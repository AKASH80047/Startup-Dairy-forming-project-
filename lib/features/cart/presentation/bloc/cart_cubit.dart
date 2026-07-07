import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(CartEntity.empty()));

  /// Adds an item to the cart or increments its quantity if it already exists.
  void addItem(CartItem item) {
    final currentItems = List<CartItem>.from(state.cart.items);
    final existingIndex = currentItems.indexWhere((i) => i.id == item.id);

    if (existingIndex >= 0) {
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      currentItems.add(item);
    }

    _updateCartState(items: currentItems);
  }

  /// Removes an item from the cart.
  void removeItem(String itemId) {
    final currentItems = List<CartItem>.from(state.cart.items);
    currentItems.removeWhere((item) => item.id == itemId);

    _updateCartState(items: currentItems);
  }

  /// Updates the quantity of a specific item in the cart.
  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final currentItems = List<CartItem>.from(state.cart.items);
    final index = currentItems.indexWhere((item) => item.id == itemId);

    if (index >= 0) {
      currentItems[index] = currentItems[index].copyWith(quantity: newQuantity);
    }

    _updateCartState(items: currentItems);
  }

  /// Updates the delivery distance and computes the corresponding delivery fee.
  void updateDeliveryDistance(double? distance) {
    double fee = 0.0;
    if (distance != null) {
      if (distance <= 2.0) {
        fee = 0.0;
      } else if (distance <= 5.0) {
        fee = 20.0;
      } else if (distance <= 10.0) {
        fee = 40.0;
      } else {
        fee = 9999.0; // Delivery unavailable marker
      }
    }

    emit(CartState(
      state.cart.copyWith(
        deliveryDistance: distance,
        deliveryCharge: fee,
      ),
    ));
  }

  /// Clears all items from the cart.
  void clearCart() {
    emit(CartState(CartEntity.empty()));
  }

  /// Helper to update state variables and recalculate totals.
  void _updateCartState({List<CartItem>? items}) {
    emit(CartState(
      state.cart.copyWith(
        items: items ?? state.cart.items,
      ),
    ));
  }
}
