import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/settings_bloc.dart';

class RegistrationStatusPage extends StatelessWidget {
  const RegistrationStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              context.setLocale(locale);
              context.read<SettingsBloc>().add(
                SettingsEvent.updateLanguage(locale),
              );
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: Row(
                  children: [
                    const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Text('lang_english'.tr()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('fr'),
                child: Row(
                  children: [
                    const Text('🇫🇷', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Text('lang_french'.tr()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.mapOrNull(
            error: (e) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message), backgroundColor: Colors.red),
            ),
            unauthorized: (u) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Still waiting for approval. Check the dashboard.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeMap(
            loading: (_) => const Center(child: CircularProgressIndicator()),
            unauthorized: (u) => _buildStatusView(context, u.identity.deviceId, false),
            authorized: (a) => _buildStatusView(context, a.identity.deviceId, true),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildStatusView(BuildContext context, String deviceId, bool isAuthorized) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAuthorized ? Icons.check_circle_outline : Icons.phonelink_lock,
              size: 80,
              color: isAuthorized ? Colors.green : theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              isAuthorized ? 'reg_device_registered'.tr() : 'reg_device_not_registered'.tr(),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            const SizedBox(height: 12),
            Text(
              isAuthorized
                  ? 'reg_device_part_of_fleet'.tr()
                  : 'reg_share_device_id'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ).tr(),
            if (!isAuthorized) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: SelectableText(
                  deviceId,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: deviceId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('reg_copied_clipboard'.tr())),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: Text('reg_copy'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      SharePlus.instance.share(ShareParams(
                        text: '${'reg_share_message'.tr()}: $deviceId',
                      ));
                    },
                    icon: const Icon(Icons.share),
                    label: Text('reg_share'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEvent.initialize());
                },
                icon: const Icon(Icons.refresh),
                label: Text('reg_check_status'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
