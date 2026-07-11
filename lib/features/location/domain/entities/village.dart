import 'package:equatable/equatable.dart';

class Village extends Equatable {
  final String code;
  final String subDistrictCode;
  final String nameEn;
  final String? nameHi;

  const Village({
    required this.code,
    required this.subDistrictCode,
    required this.nameEn,
    this.nameHi,
  });

  @override
  List<Object?> get props => [code, subDistrictCode, nameEn, nameHi];
}
