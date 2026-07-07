import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class MockProductRepository implements ProductRepository {
  static const List<ProductModel> _mockProducts = [
    ProductModel(
      id: 'prod_paneer',
      nameEnglish: 'Premium Fresh Paneer',
      nameHindi: 'ताज़ा पनीर',
      descriptionEnglish: 'Freshly prepared soft cottage cheese made from pure wholesome buffalo milk.',
      descriptionHindi: 'शुद्ध और ताजे भैंस के दूध से तैयार किया गया अत्यंत नरम और स्वादिष्ट पनीर।',
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?q=80&w=600&auto=format&fit=crop',
      price: 220.0,
      unitEnglish: '500g',
      unitHindi: '५०० ग्राम',
      isAvailable: true,
      availableQuantity: 40.0,
    ),
    ProductModel(
      id: 'prod_curd',
      nameEnglish: 'Thick Creamy Curd (Dahi)',
      nameHindi: 'गाढ़ा दही',
      descriptionEnglish: 'Thick and creamy traditional home-style dahi, naturally set and rich in probiotics.',
      descriptionHindi: 'पारंपरिक घरेलू तरीके से जमाया हुआ गाढ़ा और मलाईदार दही, जो पाचन के लिए सर्वोत्तम है।',
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=600&auto=format&fit=crop',
      price: 45.0,
      unitEnglish: '500ml',
      unitHindi: '५०० मिलीलीटर',
      isAvailable: true,
      availableQuantity: 60.0,
    ),
    ProductModel(
      id: 'prod_ghee',
      nameEnglish: 'Pure Cow Desi Ghee',
      nameHindi: 'शुद्ध गाय का देसी घी',
      descriptionEnglish: 'Traditional Danedar Ghee prepared from high quality butter, rich in aroma and taste.',
      descriptionHindi: 'सर्वोत्तम मक्खन से पारंपरिक विधि द्वारा तैयार दानेदार घी, जो सुगंध और स्वाद से भरपूर है।',
      imageUrl: 'https://images.unsplash.com/photo-1589733901241-5e5148b8979e?q=80&w=600&auto=format&fit=crop',
      price: 750.0,
      unitEnglish: '1L',
      unitHindi: '१ लीटर',
      isAvailable: true,
      availableQuantity: 25.0,
    ),
    ProductModel(
      id: 'prod_buttermilk',
      nameEnglish: 'Refreshing Spiced Buttermilk (Chach)',
      nameHindi: 'मसाला छाछ (मट्ठा)',
      descriptionEnglish: 'Refreshing traditional buttermilk blended with roasted cumin, fresh coriander, and black salt.',
      descriptionHindi: 'भुने जीरे, ताजी धनिया और काले नमक के मिश्रण से तैयार ठंडी और पाचक मसाला छाछ।',
      imageUrl: 'https://images.unsplash.com/photo-1528750951167-a2419ec6b0b0?q=80&w=600&auto=format&fit=crop',
      price: 20.0,
      unitEnglish: '500ml',
      unitHindi: '५०० मिलीलीटर',
      isAvailable: true,
      availableQuantity: 100.0,
    ),
  ];

  @override
  Future<List<ProductEntity>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockProducts;
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockProducts.firstWhere((prod) => prod.id == id);
    } catch (_) {
      return null;
    }
  }
}
