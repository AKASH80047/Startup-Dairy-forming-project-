import 'package:flutter_test/flutter_test.dart';
import 'package:pandey/features/location/domain/entities/administrative_state.dart';
import 'package:pandey/features/location/domain/entities/district.dart';
import 'package:pandey/features/location/domain/entities/sub_district.dart';
import 'package:pandey/features/location/domain/entities/village.dart';
import 'package:pandey/features/location/domain/repositories/location_repository.dart';
import 'package:pandey/features/location/domain/usecases/location_usecases.dart';
import 'package:pandey/features/location/presentation/bloc/administrative_location_bloc.dart';
import 'package:pandey/features/location/presentation/bloc/administrative_location_event.dart';
import 'package:pandey/features/location/presentation/bloc/administrative_location_state.dart';

// Simple mock implementation of LocationRepository
class MockLocationRepository implements LocationRepository {
  @override
  Future<List<AdministrativeState>> getStates() async {
    return const [
      AdministrativeState(code: '9', nameEn: 'Uttar Pradesh', nameHi: 'उत्तर प्रदेश', type: 'STATE'),
    ];
  }

  @override
  Future<List<District>> getDistricts(String stateCode) async {
    return const [
      District(code: 'UP_01', stateCode: '9', nameEn: 'Siddharthnagar', nameHi: 'सिद्धार्थनगर'),
    ];
  }

  @override
  Future<List<SubDistrict>> getSubDistricts(String districtCode) async {
    return const [
      SubDistrict(code: 'SN_TEH_01', districtCode: 'UP_01', nameEn: 'Naugarh', nameHi: 'नौगढ़'),
    ];
  }

  @override
  Future<List<Village>> searchVillages({
    required String subDistrictCode,
    required String query,
    required int page,
    required int limit,
  }) async {
    return const [
      Village(code: 'SN_VILL_01', subDistrictCode: 'SN_TEH_01', nameEn: 'Naugarh', nameHi: 'नौगढ़'),
    ];
  }
}

void main() {
  late MockLocationRepository mockRepository;
  late GetStatesUseCase getStatesUseCase;
  late GetDistrictsUseCase getDistrictsUseCase;
  late GetSubDistrictsUseCase getSubDistrictsUseCase;
  late SearchVillagesUseCase searchVillagesUseCase;
  late AdministrativeLocationBloc bloc;

  setUp(() {
    mockRepository = MockLocationRepository();
    getStatesUseCase = GetStatesUseCase(mockRepository);
    getDistrictsUseCase = GetDistrictsUseCase(mockRepository);
    getSubDistrictsUseCase = GetSubDistrictsUseCase(mockRepository);
    searchVillagesUseCase = SearchVillagesUseCase(mockRepository);
    bloc = AdministrativeLocationBloc(
      getStatesUseCase: getStatesUseCase,
      getDistrictsUseCase: getDistrictsUseCase,
      getSubDistrictsUseCase: getSubDistrictsUseCase,
      searchVillagesUseCase: searchVillagesUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('Initial state is empty and default initialized', () {
    expect(bloc.state, const AdministrativeLocationState());
  });

  group('LoadStatesRequested Tests', () {
    test('Loads states successfully and updates state lists', () async {
      bloc.add(LoadStatesRequested());
      
      // Wait for async events to settle
      await qdWait();

      expect(bloc.state.states.length, 1);
      expect(bloc.state.states.first.nameEn, 'Uttar Pradesh');
      expect(bloc.state.isLoadingStates, false);
    });
  });

  group('Cascading Selection Tests', () {
    test('StateSelected fetches districts and resets downstream selections', () async {
      const selectedState = AdministrativeState(code: '9', nameEn: 'Uttar Pradesh', type: 'STATE');
      
      bloc.add(const StateSelected(selectedState));
      await qdWait();

      expect(bloc.state.selectedState, selectedState);
      expect(bloc.state.districts.length, 1);
      expect(bloc.state.selectedDistrict, isNull);
      expect(bloc.state.selectedSubDistrict, isNull);
      expect(bloc.state.selectedVillage, isNull);
    });

    test('DistrictSelected fetches tehsils and resets downstream selections', () async {
      const selectedDistrict = District(code: 'UP_01', stateCode: '9', nameEn: 'Siddharthnagar');
      
      bloc.add(const DistrictSelected(selectedDistrict));
      await qdWait();

      expect(bloc.state.selectedDistrict, selectedDistrict);
      expect(bloc.state.subDistricts.length, 1);
      expect(bloc.state.selectedSubDistrict, isNull);
      expect(bloc.state.selectedVillage, isNull);
    });

    test('SubDistrictSelected fetches villages and resets downstream selections', () async {
      const selectedSubDistrict = SubDistrict(code: 'SN_TEH_01', districtCode: 'UP_01', nameEn: 'Naugarh');
      
      bloc.add(const SubDistrictSelected(selectedSubDistrict));
      await qdWait();

      expect(bloc.state.selectedSubDistrict, selectedSubDistrict);
      expect(bloc.state.villages.length, 1);
      expect(bloc.state.selectedVillage, isNull);
    });

    test('VillageSelected updates selected village in state', () async {
      const selectedVillage = Village(code: 'SN_VILL_01', subDistrictCode: 'SN_TEH_01', nameEn: 'Naugarh');
      
      bloc.add(const VillageSelected(selectedVillage));
      await qdWait();

      expect(bloc.state.selectedVillage, selectedVillage);
    });

    test('AdministrativeLocationReset resets state back to default state', () async {
      bloc.add(AdministrativeLocationReset());
      await qdWait();

      expect(bloc.state, const AdministrativeLocationState());
    });
  });
}

// Micro helper to wait for microtasks/bloc streams to resolve
Future<void> qdWait() => Future.delayed(Duration.zero);
