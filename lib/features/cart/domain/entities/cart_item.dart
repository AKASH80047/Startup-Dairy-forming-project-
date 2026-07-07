import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id; // Unique key: combo of productId/breedId and unit choice
  final String productId; // Original ID of the breed or product
  final String nameEnglish;
  final String nameHindi;
  final String imageUrl;
  final double price; // Price per unit
  final String unit; // Selected unit (e.g., "500ml", "1L", "500g")
  final int quantity; // Number of units ordered
  final bool isMilk; // Flag distinguishing milk from other items

  const CartItem({
    required this.id,
    required this.productId,
    required this.nameEnglish,
    required this.nameHindi,
    required this.imageUrl,
    required this.price,
    required this.unit,
    required this.quantity,
    required this.isMilk,
  });

  double get subtotal => price * quantity;

  CartItem copyWith({
    int? quantity,
  }) {
    return CartItem(
      id: id,
      productId: productId,
      nameEnglish: nameEnglish,
      nameHindi: nameHindi,
      imageUrl: imageUrl,
      price: price,
      unit: unit,
      quantity: quantity ?? this.quantity,
      isMilk: isMilk,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'nameEnglish': nameEnglish,
      'nameHindi': nameHindi,
      'imageUrl': imageUrl,
      'price': price,
      'unit': unit,
      'quantity': quantity,
      'isMilk': isMilk,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameHindi: json['nameHindi'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      quantity: json['quantity'] as int,
      isMilk: json['isMilk'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        nameEnglish,
        nameHindi,
        imageUrl,
        price,
        unit,
        quantity,
        isMilk,
      ];
}
