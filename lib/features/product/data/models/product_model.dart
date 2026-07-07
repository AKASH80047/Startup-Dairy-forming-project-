import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.nameEnglish,
    required super.nameHindi,
    required super.descriptionEnglish,
    required super.descriptionHindi,
    required super.imageUrl,
    required super.price,
    required super.unitEnglish,
    required super.unitHindi,
    required super.isAvailable,
    required super.availableQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameHindi: json['nameHindi'] as String,
      descriptionEnglish: json['descriptionEnglish'] as String,
      descriptionHindi: json['descriptionHindi'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      unitEnglish: json['unitEnglish'] as String,
      unitHindi: json['unitHindi'] as String,
      isAvailable: json['isAvailable'] as bool,
      availableQuantity: (json['availableQuantity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEnglish': nameEnglish,
      'nameHindi': nameHindi,
      'descriptionEnglish': descriptionEnglish,
      'descriptionHindi': descriptionHindi,
      'imageUrl': imageUrl,
      'price': price,
      'unitEnglish': unitEnglish,
      'unitHindi': unitHindi,
      'isAvailable': isAvailable,
      'availableQuantity': availableQuantity,
    };
  }
}
