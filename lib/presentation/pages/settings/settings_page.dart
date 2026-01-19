import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../bloc/settings_bloc.dart';
import '../../bloc/tracking_bloc.dart';
import '../../../core/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return state.maybeMap(
            loaded: (loadedState) => ListView(
              children: [
                _buildSectionHeader(context, 'settings_appearance'),
                _buildThemeSelector(context, loadedState),
                const Divider(),
                _buildSectionHeader(context, 'settings_tracking'),
                _buildTrackingControl(context, loadedState),
                const Divider(),
                _buildSectionHeader(context, 'settings_language'),
                _buildLanguageSelector(context, loadedState),
              ],
            ),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.tr(),
        style: const TextStyle(
          color: AppTheme.primaryPink,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsLoaded state) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Text('theme_system'.tr()),
            value: ThemeMode.system,
            groupValue: state.themeMode,
            activeColor: AppTheme.primaryPink,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsEvent.updateTheme(value),
                );
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text('theme_dark'.tr()),
            value: ThemeMode.dark,
            groupValue: state.themeMode,
            activeColor: AppTheme.primaryPink,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsEvent.updateTheme(value),
                );
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text('theme_light'.tr()),
            value: ThemeMode.light,
            groupValue: state.themeMode,
            activeColor: AppTheme.primaryPink,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsEvent.updateTheme(value),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsLoaded state) {

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text('lang_english'.tr()),
            leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
            trailing: state.locale.languageCode == 'en'
                ? const Icon(Icons.check, color: AppTheme.primaryPink)
                : null,
            onTap: () {
              context.setLocale(const Locale('en'));
              context.read<SettingsBloc>().add(
                const SettingsEvent.updateLanguage(Locale('en')),
              );
            },
          ),
          ListTile(
            title: Text('lang_french'.tr()),
            leading: const Text('🇫🇷', style: TextStyle(fontSize: 24)),
            trailing: state.locale.languageCode == 'fr'
                ? const Icon(Icons.check, color: AppTheme.primaryPink)
                : null,
            onTap: () {
              context.setLocale(const Locale('fr'));
              context.read<SettingsBloc>().add(
                const SettingsEvent.updateLanguage(Locale('fr')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingControl(BuildContext context, SettingsLoaded loadedState) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        final bool active = state.maybeMap(
          active: (_) => true,
          loading: (_) => true,
          orElse: () => false,
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
         child: SwitchListTile(
            title: Text('tracking_background'.tr()),
            subtitle: Text(active ? 'tracking_active_status'.tr() : 'tracking_inactive_status'.tr()),
            value: active,
            activeTrackColor: AppTheme.primaryPink,
            onChanged: (value) {
              if (value) {
                context.read<TrackingBloc>().add(const TrackingEvent.start());
              } else {
                context.read<TrackingBloc>().add(const TrackingEvent.stop());
              }
            },
            secondary: Icon(
              Icons.gps_fixed,
              color: active ? AppTheme.primaryPink : null,
            ),
          ),
        );
      },
    );
  }
}
