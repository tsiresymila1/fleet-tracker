import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../../core/theme/app_theme.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [const Color(0xFF09090B), const Color(0xFF18181B)]
            : [Colors.white, Colors.grey.shade50],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon Container
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: (isAuthorized ? Colors.green : AppTheme.primaryPink).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (isAuthorized ? Colors.green : AppTheme.primaryPink).withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        isAuthorized ? Icons.check_circle_rounded : Icons.sensors,
                        size: 80,
                        color: isAuthorized ? Colors.green : AppTheme.primaryPink,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              
              // Status Header
              Text(
                isAuthorized ? 'reg_device_registered'.tr() : 'reg_device_not_registered'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isAuthorized
                    ? 'reg_device_part_of_fleet'.tr()
                    : 'reg_share_device_id'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              
              if (!isAuthorized) ...[
                const SizedBox(height: 48),
                
                // Device ID Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900.withValues(alpha: 0.5) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'reg_device_id'.tr().toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        deviceId,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          letterSpacing: 1,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        icon: Icons.copy_rounded,
                        label: 'reg_copy'.tr(),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: deviceId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('reg_copied_clipboard'.tr()),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        icon: Icons.share_rounded,
                        label: 'reg_share'.tr(),
                        isPrimary: true,
                        onPressed: () {
                          SharePlus.instance.share(ShareParams(
                            text: '${'reg_share_message'.tr()}: $deviceId',
                          ));
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                TextButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEvent.initialize());
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    'reg_check_status'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryPink,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required IconData icon, 
    required String label, 
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary 
          ? AppTheme.primaryPink 
          : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
        foregroundColor: isPrimary 
          ? Colors.white 
          : (isDark ? Colors.white : Colors.grey.shade900),
        elevation: isPrimary ? 4 : 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
