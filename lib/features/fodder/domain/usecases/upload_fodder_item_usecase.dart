import '../entities/fodder_item_entity.dart';
import '../repositories/fodder_repository.dart';

class UploadFodderItemUseCase {
  final FodderRepository repository;

  UploadFodderItemUseCase(this.repository);

  Future<void> call(FodderItemEntity item) {
    return repository.uploadFodderItem(item);
  }
}
