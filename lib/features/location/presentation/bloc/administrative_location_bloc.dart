import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/location_usecases.dart';
import 'administrative_location_event.dart';
import 'administrative_location_state.dart';

class AdministrativeLocationBloc extends Bloc<AdministrativeLocationEvent, AdministrativeLocationState> {
  final GetStatesUseCase getStatesUseCase;
  final GetDistrictsUseCase getDistrictsUseCase;
  final GetSubDistrictsUseCase getSubDistrictsUseCase;
  final SearchVillagesUseCase searchVillagesUseCase;

  AdministrativeLocationBloc({
    required this.getStatesUseCase,
    required this.getDistrictsUseCase,
    required this.getSubDistrictsUseCase,
    required this.searchVillagesUseCase,
  }) : super(const AdministrativeLocationState()) {
    on<LoadStatesRequested>(_onLoadStatesRequested);
    on<StateSelected>(_onStateSelected);
    on<DistrictSelected>(_onDistrictSelected);
    on<SubDistrictSelected>(_onSubDistrictSelected);
    on<VillageSearchQueryChanged>(_onVillageSearchQueryChanged);
    on<VillageSelected>(_onVillageSelected);
    on<AdministrativeLocationReset>(_onReset);
  }

  Future<void> _onLoadStatesRequested(
    LoadStatesRequested event,
    Emitter<AdministrativeLocationState> emit,
  ) async {
    emit(state.copyWith(isLoadingStates: true, errorMessage: () => null));
    try {
      final states = await getStatesUseCase();
      emit(state.copyWith(states: states, isLoadingStates: false));
    } catch (e) {
      emit(state.copyWith(
        isLoadingStates: false,
        errorMessage: () => 'Failed to load states: ${e.toString()}',
      ));
    }
  }

  Future<void> _onStateSelected(
    StateSelected event,
    Emitter<AdministrativeLocationState> emit,
  ) async {
    // Cascading reset: clear old district, tehsil, and village when state changes
    emit(state.copyWith(
      selectedState: () => event.state,
      selectedDistrict: () => null,
      selectedSubDistrict: () => null,
      selectedVillage: () => null,
      districts: const [],
      subDistricts: const [],
      villages: const [],
      villageSearchQuery: '',
    ));

    if (event.state != null) {
      emit(state.copyWith(isLoadingDistricts: true, errorMessage: () => null));
      try {
        final districts = await getDistrictsUseCase(event.state!.code);
        emit(state.copyWith(districts: districts, isLoadingDistricts: false));
      } catch (e) {
        emit(state.copyWith(
          isLoadingDistricts: false,
          errorMessage: () => 'Failed to load districts: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onDistrictSelected(
    DistrictSelected event,
    Emitter<AdministrativeLocationState> emit,
  ) async {
    // Cascading reset: clear old tehsil and village when district changes
    emit(state.copyWith(
      selectedDistrict: () => event.district,
      selectedSubDistrict: () => null,
      selectedVillage: () => null,
      subDistricts: const [],
      villages: const [],
      villageSearchQuery: '',
    ));

    if (event.district != null) {
      emit(state.copyWith(isLoadingSubDistricts: true, errorMessage: () => null));
      try {
        final subDistricts = await getSubDistrictsUseCase(event.district!.code);
        emit(state.copyWith(subDistricts: subDistricts, isLoadingSubDistricts: false));
      } catch (e) {
        emit(state.copyWith(
          isLoadingSubDistricts: false,
          errorMessage: () => 'Failed to load sub-districts: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onSubDistrictSelected(
    SubDistrictSelected event,
    Emitter<AdministrativeLocationState> emit,
  ) async {
    // Cascading reset: clear old village when sub-district changes
    emit(state.copyWith(
      selectedSubDistrict: () => event.subDistrict,
      selectedVillage: () => null,
      villages: const [],
      villageSearchQuery: '',
    ));

    if (event.subDistrict != null) {
      emit(state.copyWith(isSearchingVillages: true, errorMessage: () => null));
      try {
        final villages = await searchVillagesUseCase(
          subDistrictCode: event.subDistrict!.code,
          query: '',
          page: 1,
          limit: 30,
        );
        emit(state.copyWith(villages: villages, isSearchingVillages: false));
      } catch (e) {
        emit(state.copyWith(
          isSearchingVillages: false,
          errorMessage: () => 'Failed to load villages: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onVillageSearchQueryChanged(
    VillageSearchQueryChanged event,
    Emitter<AdministrativeLocationState> emit,
  ) async {
    emit(state.copyWith(villageSearchQuery: event.query));

    if (state.selectedSubDistrict != null) {
      emit(state.copyWith(isSearchingVillages: true, errorMessage: () => null));
      try {
        final villages = await searchVillagesUseCase(
          subDistrictCode: state.selectedSubDistrict!.code,
          query: event.query,
          page: 1,
          limit: 30,
        );
        emit(state.copyWith(villages: villages, isSearchingVillages: false));
      } catch (e) {
        emit(state.copyWith(
          isSearchingVillages: false,
          errorMessage: () => 'Failed to search villages: ${e.toString()}',
        ));
      }
    }
  }

  void _onVillageSelected(
    VillageSelected event,
    Emitter<AdministrativeLocationState> emit,
  ) {
    emit(state.copyWith(selectedVillage: () => event.village));
  }

  void _onReset(
    AdministrativeLocationReset event,
    Emitter<AdministrativeLocationState> emit,
  ) {
    emit(const AdministrativeLocationState());
  }
}
