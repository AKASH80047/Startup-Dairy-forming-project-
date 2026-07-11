import '../../domain/entities/administrative_state.dart';
import '../../domain/entities/district.dart';
import '../../domain/entities/sub_district.dart';
import '../../domain/entities/village.dart';

class StateModel extends AdministrativeState {
  const StateModel({
    required super.code,
    required super.nameEn,
    super.nameHi,
    required super.type,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      code: json['code']?.toString() ?? '',
      nameEn: json['nameEn']?.toString() ?? json['name_en']?.toString() ?? '',
      nameHi: json['nameHi']?.toString() ?? json['name_hi']?.toString(),
      type: json['type']?.toString() ?? 'STATE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'nameEn': nameEn,
      'nameHi': nameHi,
      'type': type,
    };
  }
}

class DistrictModel extends District {
  const DistrictModel({
    required super.code,
    required super.stateCode,
    required super.nameEn,
    super.nameHi,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      code: json['code']?.toString() ?? '',
      stateCode: json['stateCode']?.toString() ?? json['state_code']?.toString() ?? '',
      nameEn: json['nameEn']?.toString() ?? json['name_en']?.toString() ?? '',
      nameHi: json['nameHi']?.toString() ?? json['name_hi']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'stateCode': stateCode,
      'nameEn': nameEn,
      'nameHi': nameHi,
    };
  }
}

class SubDistrictModel extends SubDistrict {
  const SubDistrictModel({
    required super.code,
    required super.districtCode,
    required super.nameEn,
    super.nameHi,
  });

  factory SubDistrictModel.fromJson(Map<String, dynamic> json) {
    return SubDistrictModel(
      code: json['code']?.toString() ?? '',
      districtCode: json['districtCode']?.toString() ?? json['district_code']?.toString() ?? '',
      nameEn: json['nameEn']?.toString() ?? json['name_en']?.toString() ?? '',
      nameHi: json['nameHi']?.toString() ?? json['name_hi']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'districtCode': districtCode,
      'nameEn': nameEn,
      'nameHi': nameHi,
    };
  }
}

class VillageModel extends Village {
  const VillageModel({
    required super.code,
    required super.subDistrictCode,
    required super.nameEn,
    super.nameHi,
  });

  factory VillageModel.fromJson(Map<String, dynamic> json) {
    return VillageModel(
      code: json['code']?.toString() ?? '',
      subDistrictCode: json['subDistrictCode']?.toString() ?? json['sub_district_code']?.toString() ?? '',
      nameEn: json['nameEn']?.toString() ?? json['name_en']?.toString() ?? '',
      nameHi: json['nameHi']?.toString() ?? json['name_hi']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'subDistrictCode': subDistrictCode,
      'nameEn': nameEn,
      'nameHi': nameHi,
    };
  }
}
