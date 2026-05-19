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
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) {
        /// DON'T REBUILD ROUTER DURING LOGIN LOADING
        if (current.status == AuthStatus.loading && previous.session == null) {
          return false;
        }

        return previous.status != current.status ||
            previous.appLocked != current.appLocked;
      },

      builder: (context, state) {
        /// =====================================================
        /// INITIAL APP BOOT ONLY
        /// =====================================================

        if (state.status == AuthStatus.initial) {
          return const SplashPage();
        }

        /// =====================================================
        /// LOCK SCREEN
        /// =====================================================

        if (state.shouldShowLockScreen ||
            state.status == AuthStatus.locked ||
            state.status == AuthStatus.pinRequired ||
            state.status == AuthStatus.biometricRequired) {
          return const LockScreenPage();
        }

        /// =====================================================
        /// SECURITY SETUP
        /// =====================================================

        if (state.status == AuthStatus.setupSecurity) {
          return const SecuritySetupPage();
        }

        /// =====================================================
        /// AUTHENTICATED
        /// =====================================================

        if (state.isAuthenticated && state.canAccessApp) {
          return const HomePage();
        }

        /// =====================================================
        /// LOGIN
        /// =====================================================

        return const LoginPage();
      },
    );
  }
}
