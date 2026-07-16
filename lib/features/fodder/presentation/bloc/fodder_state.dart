import '../../domain/entities/fodder_item_entity.dart';

abstract class FodderState {
  const FodderState();
}

class FodderInitial extends FodderState {
  const FodderInitial();
}

class FodderLoading extends FodderState {
  const FodderLoading();
}

class FodderLoaded extends FodderState {
  final List<FodderItemEntity> items;
  final String? selectedCategory;
  final String? activeSearch;

  const FodderLoaded({
    required this.items,
    this.selectedCategory,
    this.activeSearch,
  });

  FodderLoaded copyWith({
    List<FodderItemEntity>? items,
    String? selectedCategory,
    String? activeSearch,
  }) {
    return FodderLoaded(
      items: items ?? this.items,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      activeSearch: activeSearch ?? this.activeSearch,
    );
  }
}

class FodderError extends FodderState {
  final String message;
  const FodderError(this.message);
}

class FodderUploadSuccess extends FodderState {
  const FodderUploadSuccess();
}
