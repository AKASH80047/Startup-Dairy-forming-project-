import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/fodder_item_entity.dart';
import '../../domain/usecases/get_fodder_items_usecase.dart';
import '../../domain/usecases/upload_fodder_item_usecase.dart';
import 'fodder_state.dart';

class FodderCubit extends Cubit<FodderState> {
  final GetFodderItemsUseCase getFodderItemsUseCase;
  final UploadFodderItemUseCase uploadFodderItemUseCase;

  FodderCubit({
    required this.getFodderItemsUseCase,
    required this.uploadFodderItemUseCase,
  }) : super(const FodderInitial());

  Future<void> fetchFodderItems({
    String? category,
    String? search,
    String? state,
    String? district,
    String? village,
    double? maxPrice,
  }) async {
    emit(const FodderLoading());
    try {
      final items = await getFodderItemsUseCase(
        category: category,
        search: search,
        state: state,
        district: district,
        village: village,
        maxPrice: maxPrice,
      );
      emit(FodderLoaded(
        items: items,
        selectedCategory: category,
        activeSearch: search,
      ));
    } catch (e) {
      emit(FodderError(e.toString()));
    }
  }

  Future<void> uploadFodder(FodderItemEntity item) async {
    emit(const FodderLoading());
    try {
      await uploadFodderItemUseCase(item);
      emit(const FodderUploadSuccess());
      // Re-fetch default listings
      await fetchFodderItems();
    } catch (e) {
      emit(FodderError(e.toString()));
    }
  }
}
