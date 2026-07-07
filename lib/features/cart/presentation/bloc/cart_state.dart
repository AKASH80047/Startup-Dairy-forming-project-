import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';

class CartState extends Equatable {
  final CartEntity cart;

  const CartState(this.cart);

  @override
  List<Object?> get props => [cart];
}
