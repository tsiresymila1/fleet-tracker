import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/settings_bloc.dart';
import 'presentation/bloc/tracking_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  await setupDependencies();

  // Request location permissions early
  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  } catch (e) {
    debugPrint('Permission request error: $e');
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: getIt<AuthBloc>()..add(const AuthEvent.initialize()),
        ),
        BlocProvider<SettingsBloc>(create: (_) => getIt<SettingsBloc>()),
        BlocProvider<TrackingBloc>(create: (_) => getIt<TrackingBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          final themeMode = settingsState.maybeMap(
            loaded: (s) => s.themeMode,
            orElse: () => ThemeMode.dark,
          );
          // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: themeMode == ThemeMode.dark
                  ? Brightness.light
                  : Brightness.dark,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
          );

          return MaterialApp.router(
            title: 'Fleet Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            localizationsDelegates: [
              ...context.localizationDelegates,
              FormBuilderLocalizations.delegate,
            ],
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: false,
            checkerboardRasterCacheImages: false,
            checkerboardOffscreenLayers: false,
            showSemanticsDebugger: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
