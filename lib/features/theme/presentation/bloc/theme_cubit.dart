import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enum/theme_type.dart';
import '../../../../core/services/storage_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final StorageService _storageService;

  ThemeCubit(this._storageService) : super(ThemeState.initial()) {
    _loadSavedTheme();
  }

  /// Initial load of the theme from local storage.
  void _loadSavedTheme() {
    final String? savedTheme = _storageService.getThemeType();
    if (savedTheme != null) {
      try {
        final ThemeType type = ThemeType.values.firstWhere(
          (t) => t.name == savedTheme,
        );
        emit(ThemeState(themeType: type));
      } catch (_) {
        emit(ThemeState.initial());
      }
    }
  }

  /// Changes the application theme and persists the choice.
  Future<void> changeTheme(ThemeType themeType) async {
    await _storageService.saveThemeType(themeType.name);
    emit(ThemeState(themeType: themeType));
  }
}
