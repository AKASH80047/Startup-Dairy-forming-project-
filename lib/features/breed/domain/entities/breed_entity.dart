import 'package:equatable/equatable.dart';
import '../../../../core/enum/animal_type.dart';
import '../../../../core/enum/a2_status.dart';

class BreedEntity extends Equatable {
  final String id;
  final String nameEnglish;
  final String nameHindi;
  final AnimalType animalType;
  final String originEnglish;
  final String originHindi;
  final String descriptionEnglish;
  final String descriptionHindi;
  final String imageUrl;
  final A2Status a2Status;
  final double averageFatMin;
  final double averageFatMax;
  final double averageYieldMin;
  final double averageYieldMax;
  final double pricePerLitre;
  final bool isAvailable;
  final String sourceVillageEnglish;
  final String sourceVillageHindi;
  final double availableQuantityLitre;

  const BreedEntity({
    required this.id,
    required this.nameEnglish,
    required this.nameHindi,
    required this.animalType,
    required this.originEnglish,
    required this.originHindi,
    required this.descriptionEnglish,
    required this.descriptionHindi,
    required this.imageUrl,
    required this.a2Status,
    required this.averageFatMin,
    required this.averageFatMax,
    required this.averageYieldMin,
    required this.averageYieldMax,
    required this.pricePerLitre,
    required this.isAvailable,
    required this.sourceVillageEnglish,
    required this.sourceVillageHindi,
    required this.availableQuantityLitre,
  });

  @override
  List<Object?> get props => [
        id,
        nameEnglish,
        nameHindi,
        animalType,
        originEnglish,
        originHindi,
        descriptionEnglish,
        descriptionHindi,
        imageUrl,
        a2Status,
        averageFatMin,
        averageFatMax,
        averageYieldMin,
        averageYieldMax,
        pricePerLitre,
        isAvailable,
        sourceVillageEnglish,
        sourceVillageHindi,
        availableQuantityLitre,
      ];
}
