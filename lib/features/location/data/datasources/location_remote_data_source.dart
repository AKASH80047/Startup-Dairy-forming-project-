import 'package:dio/dio.dart';
import '../models/location_models.dart';

abstract class LocationRemoteDataSource {
  Future<List<StateModel>> getStates();
  Future<List<DistrictModel>> getDistricts(String stateCode);
  Future<List<SubDistrictModel>> getSubDistricts(String districtCode);
  Future<List<VillageModel>> searchVillages({
    required String subDistrictCode,
    required String query,
    required int page,
    required int limit,
  });
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;

  LocationRemoteDataSourceImpl({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? 'http://localhost:3000/api/locations';

  // Local static mock database for offline fallback
  static const List<StateModel> _mockStates = [
    StateModel(code: '8', nameEn: 'Rajasthan', nameHi: 'राजस्थान', type: 'STATE'),
    StateModel(code: '9', nameEn: 'Uttar Pradesh', nameHi: 'उत्तर प्रदेश', type: 'STATE'),
    StateModel(code: '7', nameEn: 'Delhi', nameHi: 'दिल्ली', type: 'UT'),
  ];

  static const List<DistrictModel> _mockDistricts = [
    // Rajasthan
    DistrictModel(code: 'RJ_01', stateCode: '8', nameEn: 'Jaipur', nameHi: 'जयपुर'),
    DistrictModel(code: 'RJ_02', stateCode: '8', nameEn: 'Bikaner', nameHi: 'बीकानेर'),
    DistrictModel(code: 'RJ_03', stateCode: '8', nameEn: 'Jodhpur', nameHi: 'जोधपुर'),
    // Uttar Pradesh
    DistrictModel(code: 'UP_01', stateCode: '9', nameEn: 'Siddharthnagar', nameHi: 'सिद्धार्थनगर'),
    DistrictModel(code: 'UP_02', stateCode: '9', nameEn: 'Ayodhya', nameHi: 'अयोध्या'),
    DistrictModel(code: 'UP_03', stateCode: '9', nameEn: 'Gorakhpur', nameHi: 'गोरखपुर'),
    // Delhi
    DistrictModel(code: 'DL_01', stateCode: '7', nameEn: 'New Delhi', nameHi: 'नई दिल्ली'),
  ];

  static const List<SubDistrictModel> _mockSubDistricts = [
    // Jaipur, RJ
    SubDistrictModel(code: 'JP_TEH_01', districtCode: 'RJ_01', nameEn: 'Jaipur Tehsil', nameHi: 'जयपुर तहसील'),
    SubDistrictModel(code: 'JP_TEH_02', districtCode: 'RJ_01', nameEn: 'Sanganer', nameHi: 'सांगानेर'),
    // Siddharthnagar, UP
    SubDistrictModel(code: 'SN_TEH_01', districtCode: 'UP_01', nameEn: 'Naugarh', nameHi: 'नौगढ़'),
    SubDistrictModel(code: 'SN_TEH_02', districtCode: 'UP_01', nameEn: 'Bansi', nameHi: 'बांसी'),
    SubDistrictModel(code: 'SN_TEH_03', districtCode: 'UP_01', nameEn: 'Itwa', nameHi: 'इटवा'),
    SubDistrictModel(code: 'SN_TEH_04', districtCode: 'UP_01', nameEn: 'Domariaganj', nameHi: 'डुमरियागंज'),
    SubDistrictModel(code: 'SN_TEH_05', districtCode: 'UP_01', nameEn: 'Shohratgarh', nameHi: 'शोहरतगढ़'),
  ];

  static const List<VillageModel> _mockVillages = [
    // Jaipur, Sanganer
    VillageModel(code: 'JP_VILL_01', subDistrictCode: 'JP_TEH_02', nameEn: 'Gopalpura', nameHi: 'गोपालपुरा'),
    VillageModel(code: 'JP_VILL_02', subDistrictCode: 'JP_TEH_02', nameEn: 'Sodala', nameHi: 'सोडाला'),
    VillageModel(code: 'JP_VILL_03', subDistrictCode: 'JP_TEH_02', nameEn: 'Vaishali Nagar', nameHi: 'वैशाली नगर'),
    VillageModel(code: 'JP_VILL_04', subDistrictCode: 'JP_TEH_02', nameEn: 'Mansarovar', nameHi: 'मानसरोवर'),

    // Siddharthnagar, Naugarh
    VillageModel(code: 'SN_VILL_01', subDistrictCode: 'SN_TEH_01', nameEn: 'Naugarh', nameHi: 'नौगढ़'),
    VillageModel(code: 'SN_VILL_02', subDistrictCode: 'SN_TEH_01', nameEn: 'Birdpur No. 1', nameHi: 'बर्डपुर नंबर 1'),
    VillageModel(code: 'SN_VILL_03', subDistrictCode: 'SN_TEH_01', nameEn: 'Jogia', nameHi: 'जोगिया'),
    VillageModel(code: 'SN_VILL_04', subDistrictCode: 'SN_TEH_01', nameEn: 'Kakrahi', nameHi: 'ककराही'),
    VillageModel(code: 'SN_VILL_05', subDistrictCode: 'SN_TEH_01', nameEn: 'Bariji', nameHi: 'बारीजी'),
    VillageModel(code: 'SN_VILL_06', subDistrictCode: 'SN_TEH_01', nameEn: 'Nankar', nameHi: 'नानकार'),
    VillageModel(code: 'SN_VILL_07', subDistrictCode: 'SN_TEH_01', nameEn: 'Madhubani', nameHi: 'मधुबनी'),
    VillageModel(code: 'SN_VILL_08', subDistrictCode: 'SN_TEH_01', nameEn: 'Pipra', nameHi: 'पिपरा'),

    // Siddharthnagar, Bansi
    VillageModel(code: 'SN_VILL_09', subDistrictCode: 'SN_TEH_02', nameEn: 'Bansi Dehat', nameHi: 'बांसी देहात'),
    VillageModel(code: 'SN_VILL_10', subDistrictCode: 'SN_TEH_02', nameEn: 'Lalpur', nameHi: 'लालपुर'),
    VillageModel(code: 'SN_VILL_11', subDistrictCode: 'SN_TEH_02', nameEn: 'Khesraha Rural', nameHi: 'खेसरहा ग्रामीण'),
    VillageModel(code: 'SN_VILL_12', subDistrictCode: 'SN_TEH_02', nameEn: 'Semra', nameHi: 'सेमरा'),
    VillageModel(code: 'SN_VILL_13', subDistrictCode: 'SN_TEH_02', nameEn: 'Chandee', nameHi: 'चंडी'),

    // Siddharthnagar, Shohratgarh
    VillageModel(code: 'SN_VILL_14', subDistrictCode: 'SN_TEH_05', nameEn: 'Shohratgarh Dehat', nameHi: 'शोहरतगढ़ देहात'),
    VillageModel(code: 'SN_VILL_15', subDistrictCode: 'SN_TEH_05', nameEn: 'Khairati', nameHi: 'खैराती'),
    VillageModel(code: 'SN_VILL_16', subDistrictCode: 'SN_TEH_05', nameEn: 'Mudila', nameHi: 'मुदिला'),
    VillageModel(code: 'SN_VILL_17', subDistrictCode: 'SN_TEH_05', nameEn: 'Barhni Dehat', nameHi: 'बढ़नी देहात'),
  ];

  @override
  Future<List<StateModel>> getStates() async {
    try {
      final response = await _dio.get('$_baseUrl/states', options: Options(receiveTimeout: const Duration(seconds: 3)));
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => StateModel.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Fallback silently to mock database
    }
    return _mockStates;
  }

  @override
  Future<List<DistrictModel>> getDistricts(String stateCode) async {
    try {
      final response = await _dio.get('$_baseUrl/states/$stateCode/districts', options: Options(receiveTimeout: const Duration(seconds: 3)));
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => DistrictModel.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Fallback silently to mock database
    }
    return _mockDistricts.where((d) => d.stateCode == stateCode).toList();
  }

  @override
  Future<List<SubDistrictModel>> getSubDistricts(String districtCode) async {
    try {
      final response = await _dio.get('$_baseUrl/districts/$districtCode/subdistricts', options: Options(receiveTimeout: const Duration(seconds: 3)));
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => SubDistrictModel.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Fallback silently to mock database
    }
    return _mockSubDistricts.where((sd) => sd.districtCode == districtCode).toList();
  }

  @override
  Future<List<VillageModel>> searchVillages({
    required String subDistrictCode,
    required String query,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/villages/search',
        queryParameters: {
          'subDistrictCode': subDistrictCode,
          'query': query,
          'page': page,
          'limit': limit,
        },
        options: Options(receiveTimeout: const Duration(seconds: 3)),
      );
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => VillageModel.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Fallback silently to mock database
    }

    // Local filter and paginate fallback
    var filtered = _mockVillages.where((v) => v.subDistrictCode == subDistrictCode);
    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      filtered = filtered.where((v) =>
          v.nameEn.toLowerCase().contains(q) ||
          (v.nameHi != null && v.nameHi!.toLowerCase().contains(q)));
    }
    final offset = (page - 1) * limit;
    return filtered.skip(offset).take(limit).toList();
  }
}
