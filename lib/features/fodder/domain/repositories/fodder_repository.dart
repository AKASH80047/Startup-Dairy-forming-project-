import '../entities/fodder_item_entity.dart';

abstract class FodderRepository {
  Future<List<FodderItemEntity>> getFodderItems({
    String? category,
    String? search,
    String? state,
    String? district,
    String? village,
    double? maxPrice,
  });

  Future<void> uploadFodderItem(FodderItemEntity item);
}
