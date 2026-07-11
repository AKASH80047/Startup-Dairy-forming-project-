import 'package:equatable/equatable.dart';

class AdministrativeState extends Equatable {
  final String code;
  final String nameEn;
  final String? nameHi;
  final String type; // 'STATE' or 'UT'

  const AdministrativeState({
    required this.code,
    required this.nameEn,
    this.nameHi,
    required this.type,
  });

  @override
  List<Object?> get props => [code, nameEn, nameHi, type];
}
