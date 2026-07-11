import '../entities/administrative_state.dart';
import '../entities/district.dart';
import '../entities/sub_district.dart';
import '../entities/village.dart';

abstract class LocationRepository {
  Future<List<AdministrativeState>> getStates();
  Future<List<District>> getDistricts(String stateCode);
  Future<List<SubDistrict>> getSubDistricts(String districtCode);
  Future<List<Village>> searchVillages({
    required String subDistrictCode,
    required String query,
    required int page,
    required int limit,
  });
}
