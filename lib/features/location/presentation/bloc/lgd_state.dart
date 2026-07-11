import 'package:equatable/equatable.dart';

class LgdStateModel extends Equatable {
  final String stateCode;
  final String stateNameEnglish;
  final String stateNameLocal;
  final String stateCensus2011Code;
  final String stateOrUt; // "S" or "U"
  final String lastUpdated;

  const LgdStateModel({
    required this.stateCode,
    required this.stateNameEnglish,
    required this.stateNameLocal,
    required this.stateCensus2011Code,
    required this.stateOrUt,
    required this.lastUpdated,
  });

  factory LgdStateModel.fromJson(Map<String, dynamic> json) {
    return LgdStateModel(
      stateCode: json['state_code']?.toString() ?? '',
      stateNameEnglish: json['state_name_english']?.toString() ?? '',
      stateNameLocal: json['state_name_local']?.toString() ?? '',
      stateCensus2011Code: json['state_census2011_code']?.toString() ?? '',
      stateOrUt: json['state_or_ut']?.toString() ?? '',
      lastUpdated: json['last_updated']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
        stateCode,
        stateNameEnglish,
        stateNameLocal,
        stateCensus2011Code,
        stateOrUt,
        lastUpdated,
      ];
}

abstract class LgdState extends Equatable {
  const LgdState();

  @override
  List<Object?> get props => [];
}

class LgdInitial extends LgdState {}

class LgdLoading extends LgdState {}

class LgdSuccess extends LgdState {
  final List<LgdStateModel> states;
  final bool isLive;

  const LgdSuccess({required this.states, required this.isLive});

  @override
  List<Object?> get props => [states, isLive];
}

class LgdError extends LgdState {
  final String message;

  const LgdError(this.message);

  @override
  List<Object?> get props => [message];
}
