import 'package:equatable/equatable.dart';
import '../../domain/entities/administrative_state.dart';
import '../../domain/entities/district.dart';
import '../../domain/entities/sub_district.dart';
import '../../domain/entities/village.dart';

class AdministrativeLocationState extends Equatable {
  final List<AdministrativeState> states;
  final AdministrativeState? selectedState;

  final List<District> districts;
  final District? selectedDistrict;

  final List<SubDistrict> subDistricts;
  final SubDistrict? selectedSubDistrict;

  final List<Village> villages;
  final Village? selectedVillage;

  final String villageSearchQuery;

  final bool isLoadingStates;
  final bool isLoadingDistricts;
  final bool isLoadingSubDistricts;
  final bool isSearchingVillages;

  final String? errorMessage;

  const AdministrativeLocationState({
    this.states = const [],
    this.selectedState,
    this.districts = const [],
    this.selectedDistrict,
    this.subDistricts = const [],
    this.selectedSubDistrict,
    this.villages = const [],
    this.selectedVillage,
    this.villageSearchQuery = '',
    this.isLoadingStates = false,
    this.isLoadingDistricts = false,
    this.isLoadingSubDistricts = false,
    this.isSearchingVillages = false,
    this.errorMessage,
  });

  AdministrativeLocationState copyWith({
    List<AdministrativeState>? states,
    AdministrativeState? Function()? selectedState,
    List<District>? districts,
    District? Function()? selectedDistrict,
    List<SubDistrict>? subDistricts,
    SubDistrict? Function()? selectedSubDistrict,
    List<Village>? villages,
    Village? Function()? selectedVillage,
    String? villageSearchQuery,
    bool? isLoadingStates,
    bool? isLoadingDistricts,
    bool? isLoadingSubDistricts,
    bool? isSearchingVillages,
    String? Function()? errorMessage,
  }) {
    return AdministrativeLocationState(
      states: states ?? this.states,
      selectedState: selectedState != null ? selectedState() : this.selectedState,
      districts: districts ?? this.districts,
      selectedDistrict: selectedDistrict != null ? selectedDistrict() : this.selectedDistrict,
      subDistricts: subDistricts ?? this.subDistricts,
      selectedSubDistrict: selectedSubDistrict != null ? selectedSubDistrict() : this.selectedSubDistrict,
      villages: villages ?? this.villages,
      selectedVillage: selectedVillage != null ? selectedVillage() : this.selectedVillage,
      villageSearchQuery: villageSearchQuery ?? this.villageSearchQuery,
      isLoadingStates: isLoadingStates ?? this.isLoadingStates,
      isLoadingDistricts: isLoadingDistricts ?? this.isLoadingDistricts,
      isLoadingSubDistricts: isLoadingSubDistricts ?? this.isLoadingSubDistricts,
      isSearchingVillages: isSearchingVillages ?? this.isSearchingVillages,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        states,
        selectedState,
        districts,
        selectedDistrict,
        subDistricts,
        selectedSubDistrict,
        villages,
        selectedVillage,
        villageSearchQuery,
        isLoadingStates,
        isLoadingDistricts,
        isLoadingSubDistricts,
        isSearchingVillages,
        errorMessage,
      ];
}
