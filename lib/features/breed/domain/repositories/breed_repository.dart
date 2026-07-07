import '../../../../core/enum/animal_type.dart';
import '../entities/breed_entity.dart';

abstract class BreedRepository {
  /// Fetches all breeds filtered by the specified animal type (Cow or Buffalo).
  Future<List<BreedEntity>> getBreeds(AnimalType type);

  /// Fetches details for a single breed by its unique identifier.
  Future<BreedEntity?> getBreedById(String id);
}
