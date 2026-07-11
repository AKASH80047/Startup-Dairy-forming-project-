import 'package:equatable/equatable.dart';

class District extends Equatable {
  final String code;
  final String stateCode;
  final String nameEn;
  final String? nameHi;

  const District({
    required this.code,
    required this.stateCode,
    required this.nameEn,
    this.nameHi,
  });

  @override
  List<Object?> get props => [code, stateCode, nameEn, nameHi];
}
