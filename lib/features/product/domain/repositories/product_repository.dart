import '../entities/product_entity.dart';

abstract class ProductRepository {
  /// Fetches all active dairy products in the catalog.
  Future<List<ProductEntity>> getProducts();

  /// Fetches a specific product by its identifier.
  Future<ProductEntity?> getProductById(String id);
}
