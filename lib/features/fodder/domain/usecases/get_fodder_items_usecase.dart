import '../entities/fodder_item_entity.dart';
import '../repositories/fodder_repository.dart';

class GetFodderItemsUseCase {
  final FodderRepository repository;

  GetFodderItemsUseCase(this.repository);

  Future<List<FodderItemEntity>> call({
    String? category,
    String? search,
    String? state,
    String? district,
    String? village,
    double? maxPrice,
  }) {
    return repository.getFodderItems(
      category: category,
      search: search,
      state: state,
      district: district,
      village: village,
      maxPrice: maxPrice,
    );
  }
}
