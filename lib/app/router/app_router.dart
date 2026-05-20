import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_state.dart';

import 'package:fluxpay/features/auth/presentation/pages/lock_screen_page.dart';
import 'package:fluxpay/features/auth/presentation/pages/login_page.dart';
import 'package:fluxpay/features/auth/presentation/pages/security_setup_page.dart';

import 'package:fluxpay/features/exchange/presentation/pages/home_page.dart';

import 'package:fluxpay/features/splash/presentation/pages/splash_page.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, AuthStatus>(
      selector: (state) => state.status,

      builder: (context, status) {
        debugPrint('''
================ APP ROUTER ================
STATUS => $status
============================================
''');

        switch (status) {
          case AuthStatus.initial:
            return const SplashPage();

          case AuthStatus.loading:
            return const SplashPage();

          case AuthStatus.setupSecurity:
            return const SecuritySetupPage();

          case AuthStatus.authenticated:
            return const HomePage();

          case AuthStatus.locked:
          case AuthStatus.pinRequired:
          case AuthStatus.biometricRequired:
            return const LockScreenPage();

          case AuthStatus.failure:
          case AuthStatus.unauthenticated:
          default:
            return const LoginPage();
        }
      },
    );
  }
}
