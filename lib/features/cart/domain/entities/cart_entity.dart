import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class CartEntity extends Equatable {
  final List<CartItem> items;
  final double? deliveryDistance; // Distance from farm in km
  final double deliveryCharge;
  final double discount;

  const CartEntity({
    required this.items,
    this.deliveryDistance,
    required this.deliveryCharge,
    required this.discount,
  });

  factory CartEntity.empty() {
    return const CartEntity(
      items: [],
      deliveryDistance: null,
      deliveryCharge: 0.0,
      discount: 0.0,
    );
  }

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);

  double get grandTotal => subtotal + deliveryCharge - discount;

  CartEntity copyWith({
    List<CartItem>? items,
    double? deliveryDistance,
    double? deliveryCharge,
    double? discount,
  }) {
    return CartEntity(
      items: items ?? this.items,
      deliveryDistance: deliveryDistance ?? this.deliveryDistance,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      discount: discount ?? this.discount,
    );
  }

  @override
  List<Object?> get props => [
        items,
        deliveryDistance,
        deliveryCharge,
        discount,
      ];
}
