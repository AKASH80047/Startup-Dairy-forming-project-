import '../../domain/entities/breed_entity.dart';
import '../../../../core/enum/animal_type.dart';
import '../../../../core/enum/a2_status.dart';

class BreedModel extends BreedEntity {
  const BreedModel({
    required super.id,
    required super.nameEnglish,
    required super.nameHindi,
    required super.animalType,
    required super.originEnglish,
    required super.originHindi,
    required super.descriptionEnglish,
    required super.descriptionHindi,
    required super.imageUrl,
    required super.a2Status,
    required super.averageFatMin,
    required super.averageFatMax,
    required super.averageYieldMin,
    required super.averageYieldMax,
    required super.pricePerLitre,
    required super.isAvailable,
    required super.sourceVillageEnglish,
    required super.sourceVillageHindi,
    required super.availableQuantityLitre,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameHindi: json['nameHindi'] as String,
      animalType: AnimalType.values.firstWhere(
        (e) => e.name == json['animalType'],
        orElse: () => AnimalType.cow,
      ),
      originEnglish: json['originEnglish'] as String,
      originHindi: json['originHindi'] as String,
      descriptionEnglish: json['descriptionEnglish'] as String,
      descriptionHindi: json['descriptionHindi'] as String,
      imageUrl: json['imageUrl'] as String,
      a2Status: A2Status.values.firstWhere(
        (e) => e.name == json['a2Status'],
        orElse: () => A2Status.unknown,
      ),
      averageFatMin: (json['averageFatMin'] as num).toDouble(),
      averageFatMax: (json['averageFatMax'] as num).toDouble(),
      averageYieldMin: (json['averageYieldMin'] as num).toDouble(),
      averageYieldMax: (json['averageYieldMax'] as num).toDouble(),
      pricePerLitre: (json['pricePerLitre'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
      sourceVillageEnglish: json['sourceVillageEnglish'] as String,
      sourceVillageHindi: json['sourceVillageHindi'] as String,
      availableQuantityLitre: (json['availableQuantityLitre'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEnglish': nameEnglish,
      'nameHindi': nameHindi,
      'animalType': animalType.name,
      'originEnglish': originEnglish,
      'originHindi': originHindi,
      'descriptionEnglish': descriptionEnglish,
      'descriptionHindi': descriptionHindi,
      'imageUrl': imageUrl,
      'a2Status': a2Status.name,
      'averageFatMin': averageFatMin,
      'averageFatMax': averageFatMax,
      'averageYieldMin': averageYieldMin,
      'averageYieldMax': averageYieldMax,
      'pricePerLitre': pricePerLitre,
      'isAvailable': isAvailable,
      'sourceVillageEnglish': sourceVillageEnglish,
      'sourceVillageHindi': sourceVillageHindi,
      'availableQuantityLitre': availableQuantityLitre,
    };
  }
}
