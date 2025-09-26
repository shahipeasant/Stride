import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_provider.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/signup_page.dart';
import '../../features/taught/view/taught_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter needs to listen to auth state
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,

    // 👇 dynamic redirect based on auth
    redirect: (context, state) {
      final loggedIn = authState.asData?.value != null;
      final loggingIn = state.fullPath == '/login' || state.fullPath == '/signup';

      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }
      if (loggedIn && loggingIn) {
        return '/';
      }
      return null;
    },

      routes: [
        GoRoute(
          path: '/',
          redirect: (context, state) {
            final loggedIn = authState.asData?.value != null;
            return loggedIn ? '/home' : '/login';
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => TaughtPage(), // later replace with HomePage w/ tabs
        ),
      ]

  );
});