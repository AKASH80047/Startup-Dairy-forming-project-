import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/storage_service.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final StorageService _storageService;

  LanguageCubit(this._storageService) : super(LanguageState.initial()) {
    _loadSavedLanguage();
  }

  /// Initial load of the language settings from local storage.
  void _loadSavedLanguage() {
    final String? savedCode = _storageService.getLanguageCode();
    if (savedCode != null) {
      emit(LanguageState(
        locale: Locale(savedCode),
        isLanguageSelected: true,
      ));
    } else {
      // Default to English, but mark selected as false to trigger selection page
      emit(const LanguageState(
        locale: Locale('en'),
        isLanguageSelected: false,
      ));
    }
  }

  /// Changes the application language and persists the choice.
  Future<void> changeLanguage(String languageCode) async {
    await _storageService.saveLanguageCode(languageCode);
    emit(LanguageState(
      locale: Locale(languageCode),
      isLanguageSelected: true,
    ));
  }
}
