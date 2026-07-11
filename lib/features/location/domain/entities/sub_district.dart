import 'package:equatable/equatable.dart';

class SubDistrict extends Equatable {
  final String code;
  final String districtCode;
  final String nameEn;
  final String? nameHi;

  const SubDistrict({
    required this.code,
    required this.districtCode,
    required this.nameEn,
    this.nameHi,
  });

  @override
  List<Object?> get props => [code, districtCode, nameEn, nameHi];
}
