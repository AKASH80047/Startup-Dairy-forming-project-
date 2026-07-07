import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String nameEnglish;
  final String nameHindi;
  final String descriptionEnglish;
  final String descriptionHindi;
  final String imageUrl;
  final double price;
  final String unitEnglish;
  final String unitHindi;
  final bool isAvailable;
  final double availableQuantity;

  const ProductEntity({
    required this.id,
    required this.nameEnglish,
    required this.nameHindi,
    required this.descriptionEnglish,
    required this.descriptionHindi,
    required this.imageUrl,
    required this.price,
    required this.unitEnglish,
    required this.unitHindi,
    required this.isAvailable,
    required this.availableQuantity,
  });

  @override
  List<Object?> get props => [
        id,
        nameEnglish,
        nameHindi,
        descriptionEnglish,
        descriptionHindi,
        imageUrl,
        price,
        unitEnglish,
        unitHindi,
        isAvailable,
        availableQuantity,
      ];
}
