class FodderItemEntity {
  final String id;
  final String titleEn;
  final String titleHi;
  final String categoryEn;
  final String categoryHi;
  final String imageUrl;
  final double price;
  final String unitEn;
  final String unitHi;
  final double quantity;
  final String sellerName;
  final String sellerPhone;
  final String village;
  final String district;
  final String state;
  final bool deliveryAvailable;
  final DateTime createdAt;

  const FodderItemEntity({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.categoryEn,
    required this.categoryHi,
    required this.imageUrl,
    required this.price,
    required this.unitEn,
    required this.unitHi,
    required this.quantity,
    required this.sellerName,
    required this.sellerPhone,
    required this.village,
    required this.district,
    required this.state,
    required this.deliveryAvailable,
    required this.createdAt,
  });
}
