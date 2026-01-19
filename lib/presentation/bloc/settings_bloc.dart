import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState.loaded(
          themeMode: ThemeMode.dark,
          locale: Locale('en'),
        )) {
    on<SettingsUpdateTheme>(_onUpdateTheme);
    on<SettingsUpdateLanguage>(_onUpdateLanguage);
  }

  void _onUpdateTheme(SettingsUpdateTheme event, Emitter<SettingsState> emit) {
    state.maybeMap(
      loaded: (s) => emit(s.copyWith(themeMode: event.themeMode)),
      orElse: () {},
    );
  }

  void _onUpdateLanguage(SettingsUpdateLanguage event, Emitter<SettingsState> emit) {
    state.maybeMap(
      loaded: (s) => emit(s.copyWith(locale: event.locale)),
      orElse: () {},
    );
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      final themeModeStr = json['themeMode'] as String? ?? 'dark';
      final languageCode = json['languageCode'] as String? ?? 'en';

      ThemeMode themeMode;
      switch (themeModeStr) {
        case 'light':
          themeMode = ThemeMode.light;
          break;
        case 'dark':
          themeMode = ThemeMode.dark;
          break;
        default:
          themeMode = ThemeMode.system;
      }

      return SettingsState.loaded(
        themeMode: themeMode,
        locale: Locale(languageCode),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.maybeMap(
      loaded: (s) => {
        'themeMode': s.themeMode.name,
        'languageCode': s.locale.languageCode,
      },
      orElse: () => null,
    );
  }
}
