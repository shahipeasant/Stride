import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_provider.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/signup_page.dart';
import '../../features/home/view/home_page.dart';
import '../../features/splash/splash_service.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/taught/view/taught_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter needs to listen to auth state
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final splashState = ref.watch(SplashPageProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,

    // 👇 dynamic redirect based on auth
    redirect: (context, state) {
      if(!splashState.finished) {
        return null;
      }
      else
        return '/';
    },

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SplashPage(), // just show splash
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
          builder: (context, state) => HomePage(),
        ),
      ]
  );
});