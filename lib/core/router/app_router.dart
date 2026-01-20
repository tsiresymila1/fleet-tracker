import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injection.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/history_bloc.dart';
import '../../presentation/pages/auth/registration_status_page.dart';
import '../../presentation/pages/navigation/navigation_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/history/history_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
    redirect: (context, state) {
      final authBloc = getIt<AuthBloc>();
      final isAuthorized = authBloc.state.maybeMap(
        authorized: (_) => true,
        orElse: () => false,
      );
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthorized) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const RegistrationStatusPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const NavigationPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => BlocProvider(
          create: (context) => HistoryBloc(),
          child: const HistoryPage(),
        ),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
