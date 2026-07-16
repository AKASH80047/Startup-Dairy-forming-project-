import '../../domain/entities/fodder_item_entity.dart';

class FodderItemModel extends FodderItemEntity {
  const FodderItemModel({
    required super.id,
    required super.titleEn,
    required super.titleHi,
    required super.categoryEn,
    required super.categoryHi,
    required super.imageUrl,
    required super.price,
    required super.unitEn,
    required super.unitHi,
    required super.quantity,
    required super.sellerName,
    required super.sellerPhone,
    required super.village,
    required super.district,
    required super.state,
    required super.deliveryAvailable,
    required super.createdAt,
  });

  factory FodderItemModel.fromJson(Map<String, dynamic> json) {
    return FodderItemModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleHi: json['titleHi'] as String,
      categoryEn: json['categoryEn'] as String,
      categoryHi: json['categoryHi'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      unitEn: json['unitEn'] as String,
      unitHi: json['unitHi'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      sellerName: json['sellerName'] as String,
      sellerPhone: json['sellerPhone'] as String,
      village: json['village'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      deliveryAvailable: json['deliveryAvailable'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleHi': titleHi,
      'categoryEn': categoryEn,
      'categoryHi': categoryHi,
      'imageUrl': imageUrl,
      'price': price,
      'unitEn': unitEn,
      'unitHi': unitHi,
      'quantity': quantity,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'village': village,
      'district': district,
      'state': state,
      'deliveryAvailable': deliveryAvailable,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FodderItemModel.fromEntity(FodderItemEntity entity) {
    return FodderItemModel(
      id: entity.id,
      titleEn: entity.titleEn,
      titleHi: entity.titleHi,
      categoryEn: entity.categoryEn,
      categoryHi: entity.categoryHi,
      imageUrl: entity.imageUrl,
      price: entity.price,
      unitEn: entity.unitEn,
      unitHi: entity.unitHi,
      quantity: entity.quantity,
      sellerName: entity.sellerName,
      sellerPhone: entity.sellerPhone,
      village: entity.village,
      district: entity.district,
      state: entity.state,
      deliveryAvailable: entity.deliveryAvailable,
      createdAt: entity.createdAt,
    );
  }
}
