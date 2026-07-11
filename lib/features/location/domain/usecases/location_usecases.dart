import '../entities/administrative_state.dart';
import '../entities/district.dart';
import '../entities/sub_district.dart';
import '../entities/village.dart';
import '../repositories/location_repository.dart';

class GetStatesUseCase {
  final LocationRepository repository;

  GetStatesUseCase(this.repository);

  Future<List<AdministrativeState>> call() {
    return repository.getStates();
  }
}

class GetDistrictsUseCase {
  final LocationRepository repository;

  GetDistrictsUseCase(this.repository);

  Future<List<District>> call(String stateCode) {
    return repository.getDistricts(stateCode);
  }
}

class GetSubDistrictsUseCase {
  final LocationRepository repository;

  GetSubDistrictsUseCase(this.repository);

  Future<List<SubDistrict>> call(String districtCode) {
    return repository.getSubDistricts(districtCode);
  }
}

class SearchVillagesUseCase {
  final LocationRepository repository;

  SearchVillagesUseCase(this.repository);

  Future<List<Village>> call({
    required String subDistrictCode,
    required String query,
    required int page,
    required int limit,
  }) {
    return repository.searchVillages(
      subDistrictCode: subDistrictCode,
      query: query,
      page: page,
      limit: limit,
    );
  }
}
