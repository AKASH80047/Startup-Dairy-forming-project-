import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'lgd_state.dart';

class LgdCubit extends Cubit<LgdState> {
  final Dio _dio;

  LgdCubit({Dio? dio})
      : _dio = dio ?? Dio(),
        super(LgdInitial());

  static const String apiKey = '579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b';
  static const String resourceId = 'a71e60f0-a21d-43de-a6c5-fa5d21600cdb';
  static const String apiUrl = 'https://api.data.gov.in/resource/$resourceId?api-key=$apiKey&format=json&limit=50';

  final List<LgdStateModel> _fallbackStates = const [
    LgdStateModel(
      stateCode: '8',
      stateNameEnglish: 'Rajasthan',
      stateNameLocal: 'राजस्थान',
      stateCensus2011Code: '08',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '27',
      stateNameEnglish: 'Maharashtra',
      stateNameLocal: 'महाराष्ट्र',
      stateCensus2011Code: '27',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '9',
      stateNameEnglish: 'Uttar Pradesh',
      stateNameLocal: 'उत्तर प्रदेश',
      stateCensus2011Code: '09',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '24',
      stateNameEnglish: 'Gujarat',
      stateNameLocal: 'गुजरात',
      stateCensus2011Code: '24',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '2',
      stateNameEnglish: 'Himachal Pradesh',
      stateNameLocal: 'HIMACHAL PRADESH',
      stateCensus2011Code: '02',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '3',
      stateNameEnglish: 'Punjab',
      stateNameLocal: 'पंजाब',
      stateCensus2011Code: '03',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '6',
      stateNameEnglish: 'Haryana',
      stateNameLocal: 'हरियाणा',
      stateCensus2011Code: '06',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '10',
      stateNameEnglish: 'Bihar',
      stateNameLocal: 'बिहार',
      stateCensus2011Code: '10',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '19',
      stateNameEnglish: 'West Bengal',
      stateNameLocal: 'पश्चिम बंगाल',
      stateCensus2011Code: '19',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '23',
      stateNameEnglish: 'Madhya Pradesh',
      stateNameLocal: 'MADHYA PRADESH',
      stateCensus2011Code: '23',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '34',
      stateNameEnglish: 'Puducherry',
      stateNameLocal: 'PUDUCHERRY',
      stateCensus2011Code: '34',
      stateOrUt: 'U',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '7',
      stateNameEnglish: 'Delhi',
      stateNameLocal: 'दिल्ली',
      stateCensus2011Code: '07',
      stateOrUt: 'U',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '12',
      stateNameEnglish: 'Arunachal Pradesh',
      stateNameLocal: 'ARUNACHAL PRADESH',
      stateCensus2011Code: '12',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '28',
      stateNameEnglish: 'Andhra Pradesh',
      stateNameLocal: 'आंध्र प्रदेश',
      stateCensus2011Code: '28',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '29',
      stateNameEnglish: 'Karnataka',
      stateNameLocal: 'कर्नाटक',
      stateCensus2011Code: '29',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
    LgdStateModel(
      stateCode: '32',
      stateNameEnglish: 'Kerala',
      stateNameLocal: 'केरल',
      stateCensus2011Code: '32',
      stateOrUt: 'S',
      lastUpdated: '2024-10-07',
    ),
  ];

  Future<void> fetchStates() async {
    emit(LgdLoading());
    try {
      final response = await _dio.get(apiUrl);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          final List<LgdStateModel> statesList = records
              .map((json) => LgdStateModel.fromJson(json as Map<String, dynamic>))
              .toList();

          if (statesList.isEmpty) {
            emit(LgdSuccess(states: _fallbackStates, isLive: false));
          } else {
            emit(LgdSuccess(states: statesList, isLive: true));
          }
        } else if (data is Map<String, dynamic> && data.containsKey('error')) {
          // Rate limit or other service error from portal
          emit(LgdSuccess(states: _fallbackStates, isLive: false));
        } else {
          emit(LgdSuccess(states: _fallbackStates, isLive: false));
        }
      } else {
        emit(LgdSuccess(states: _fallbackStates, isLive: false));
      }
    } catch (_) {
      // Offline or network error fallback
      emit(LgdSuccess(states: _fallbackStates, isLive: false));
    }
  }
}
