part of 'language_cubit.dart';

class LanguageState extends Equatable {
  final Locale locale;
  final bool isLanguageSelected;

  const LanguageState({
    required this.locale,
    required this.isLanguageSelected,
  });

  factory LanguageState.initial() {
    return const LanguageState(
      locale: Locale('en'),
      isLanguageSelected: false,
    );
  }

  LanguageState copyWith({
    Locale? locale,
    bool? isLanguageSelected,
  }) {
    return LanguageState(
      locale: locale ?? this.locale,
      isLanguageSelected: isLanguageSelected ?? this.isLanguageSelected,
    );
  }

  @override
  List<Object?> get props => [locale, isLanguageSelected];
}
