part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.updateTheme(ThemeMode themeMode) = SettingsUpdateTheme;
  const factory SettingsEvent.updateLanguage(Locale locale) = SettingsUpdateLanguage;
}
