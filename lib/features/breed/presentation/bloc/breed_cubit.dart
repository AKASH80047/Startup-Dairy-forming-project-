import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enum/animal_type.dart';
import '../../domain/repositories/breed_repository.dart';
import 'breed_state.dart';

class BreedCubit extends Cubit<BreedState> {
  final BreedRepository _breedRepository;

  BreedCubit(this._breedRepository) : super(BreedInitial());

  /// Loads the list of breeds for a specific animal type (Cow or Buffalo).
  Future<void> fetchBreeds(AnimalType type) async {
    emit(BreedLoading());
    try {
      final breeds = await _breedRepository.getBreeds(type);
      emit(BreedLoaded(breeds));
    } catch (e) {
      emit(BreedError(e.toString()));
    }
  }

  /// Loads details for a single breed by its ID.
  Future<void> fetchBreedDetail(String id) async {
    emit(BreedLoading());
    try {
      final breed = await _breedRepository.getBreedById(id);
      if (breed != null) {
        emit(BreedDetailLoaded(breed));
      } else {
        emit(const BreedError('Breed not found'));
      }
    } catch (e) {
      emit(BreedError(e.toString()));
    }
  }
}
