import 'package:equatable/equatable.dart';

class BulkOrderItem extends Equatable {
  final String productId;
  final String nameEnglish;
  final String nameHindi;
  final double price;
  final String unit;
  final double quantity;

  const BulkOrderItem({
    required this.productId,
    required this.nameEnglish,
    required this.nameHindi,
    required this.price,
    required this.unit,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'nameEnglish': nameEnglish,
      'nameHindi': nameHindi,
      'price': price,
      'unit': unit,
      'quantity': quantity,
    };
  }

  factory BulkOrderItem.fromJson(Map<String, dynamic> json) {
    return BulkOrderItem(
      productId: json['productId'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameHindi: json['nameHindi'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        productId,
        nameEnglish,
        nameHindi,
        price,
        unit,
        quantity,
      ];
}
