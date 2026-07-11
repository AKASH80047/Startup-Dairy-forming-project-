import '../../domain/entities/administrative_state.dart';
import '../../domain/entities/district.dart';
import '../../domain/entities/sub_district.dart';
import '../../domain/entities/village.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remoteDataSource;

  LocationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<AdministrativeState>> getStates() {
    return _remoteDataSource.getStates();
  }

  @override
  Future<List<District>> getDistricts(String stateCode) {
    return _remoteDataSource.getDistricts(stateCode);
  }

  @override
  Future<List<SubDistrict>> getSubDistricts(String districtCode) {
    return _remoteDataSource.getSubDistricts(districtCode);
  }

  @override
  Future<List<Village>> searchVillages({
    required String subDistrictCode,
    required String query,
    required int page,
    required int limit,
  }) {
    return _remoteDataSource.searchVillages(
      subDistrictCode: subDistrictCode,
      query: query,
      page: page,
      limit: limit,
    );
  }
}
