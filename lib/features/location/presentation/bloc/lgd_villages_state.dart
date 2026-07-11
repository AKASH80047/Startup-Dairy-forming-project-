import 'package:equatable/equatable.dart';

class LgdVillageModel extends Equatable {
  final String villageCode;
  final String villageNameEnglish;
  final String villageNameLocal;
  final String blockName;
  final String gramPanchayatName;
  final String tehsilName;
  final String districtName;
  final String stateName;
  final String pincode;

  const LgdVillageModel({
    required this.villageCode,
    required this.villageNameEnglish,
    required this.villageNameLocal,
    required this.blockName,
    required this.gramPanchayatName,
    required this.tehsilName,
    required this.districtName,
    required this.stateName,
    required this.pincode,
  });

  factory LgdVillageModel.fromJson(Map<String, dynamic> json) {
    return LgdVillageModel(
      villageCode: json['village_code']?.toString() ?? json['village_code_lgd']?.toString() ?? '',
      villageNameEnglish: json['village_name_english']?.toString() ?? json['village_name']?.toString() ?? '',
      villageNameLocal: json['village_name_local']?.toString() ?? json['village_name_hindi']?.toString() ?? '',
      blockName: json['block_name']?.toString() ?? json['block_name_english']?.toString() ?? '',
      gramPanchayatName: json['gram_panchayat_name']?.toString() ?? json['gp_name']?.toString() ?? '',
      tehsilName: json['tehsil_name']?.toString() ?? json['subdistrict_name']?.toString() ?? '',
      districtName: json['district_name']?.toString() ?? 'Siddharthnagar',
      stateName: json['state_name']?.toString() ?? 'Uttar Pradesh',
      pincode: json['pincode']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
        villageCode,
        villageNameEnglish,
        villageNameLocal,
        blockName,
        gramPanchayatName,
        tehsilName,
        districtName,
        stateName,
        pincode,
      ];
}

abstract class LgdVillagesState extends Equatable {
  const LgdVillagesState();

  @override
  List<Object?> get props => [];
}

class LgdVillagesInitial extends LgdVillagesState {}

class LgdVillagesLoading extends LgdVillagesState {}

class LgdVillagesSuccess extends LgdVillagesState {
  final List<LgdVillageModel> villages;
  final bool isLive;

  const LgdVillagesSuccess({required this.villages, required this.isLive});

  @override
  List<Object?> get props => [villages, isLive];
}

class LgdVillagesError extends LgdVillagesState {
  final String message;

  const LgdVillagesError(this.message);

  @override
  List<Object?> get props => [message];
}
