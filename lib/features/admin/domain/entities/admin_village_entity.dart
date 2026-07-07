import 'package:equatable/equatable.dart';

class AdminVillageEntity extends Equatable {
  final String id;
  final String nameEnglish;
  final String nameHindi;
  final String district;
  final String state;
  final String pincode;
  final bool isActive;

  const AdminVillageEntity({
    required this.id,
    required this.nameEnglish,
    required this.nameHindi,
    required this.district,
    required this.state,
    required this.pincode,
    this.isActive = true,
  });

  AdminVillageEntity copyWith({
    bool? isActive,
    String? nameEnglish,
    String? nameHindi,
    String? district,
    String? state,
    String? pincode,
  }) {
    return AdminVillageEntity(
      id: id,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      nameHindi: nameHindi ?? this.nameHindi,
      district: district ?? this.district,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEnglish': nameEnglish,
      'nameHindi': nameHindi,
      'district': district,
      'state': state,
      'pincode': pincode,
      'isActive': isActive,
    };
  }

  factory AdminVillageEntity.fromJson(Map<String, dynamic> json) {
    return AdminVillageEntity(
      id: json['id'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameHindi: json['nameHindi'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nameEnglish,
        nameHindi,
        district,
        state,
        pincode,
        isActive,
      ];
}
