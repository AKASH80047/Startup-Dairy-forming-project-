import 'package:equatable/equatable.dart';
import '../../domain/entities/administrative_state.dart';
import '../../domain/entities/district.dart';
import '../../domain/entities/sub_district.dart';
import '../../domain/entities/village.dart';

abstract class AdministrativeLocationEvent extends Equatable {
  const AdministrativeLocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadStatesRequested extends AdministrativeLocationEvent {}

class StateSelected extends AdministrativeLocationEvent {
  final AdministrativeState? state;
  const StateSelected(this.state);

  @override
  List<Object?> get props => [state];
}

class DistrictSelected extends AdministrativeLocationEvent {
  final District? district;
  const DistrictSelected(this.district);

  @override
  List<Object?> get props => [district];
}

class SubDistrictSelected extends AdministrativeLocationEvent {
  final SubDistrict? subDistrict;
  const SubDistrictSelected(this.subDistrict);

  @override
  List<Object?> get props => [subDistrict];
}

class VillageSearchQueryChanged extends AdministrativeLocationEvent {
  final String query;
  const VillageSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class VillageSelected extends AdministrativeLocationEvent {
  final Village? village;
  const VillageSelected(this.village);

  @override
  List<Object?> get props => [village];
}

class AdministrativeLocationReset extends AdministrativeLocationEvent {}
