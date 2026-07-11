import 'package:equatable/equatable.dart';
import '../../../../core/enum/theme_type.dart';

class ThemeState extends Equatable {
  final ThemeType themeType;

  const ThemeState({required this.themeType});

  factory ThemeState.initial() {
    return const ThemeState(themeType: ThemeType.light);
  }

  ThemeState copyWith({
    ThemeType? themeType,
  }) {
    return ThemeState(
      themeType: themeType ?? this.themeType,
    );
  }

  @override
  List<Object?> get props => [themeType];
}
