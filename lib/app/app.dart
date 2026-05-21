import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/router/app_router.dart';
import 'package:fluxpay/app/theme/app_theme.dart';

import 'package:fluxpay/core/connectivity/connectivity_cubit.dart';
import 'package:fluxpay/core/lifecycle/app_lifecycle_handler.dart';
import 'package:fluxpay/core/session/session_wrapper.dart';

import 'package:fluxpay/features/auth/presentation/bloc/app_lock_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/app_lock_event.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_event.dart'
    hide LockAppRequested;

import 'package:fluxpay/features/auth/presentation/bloc/auth_state.dart';

import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';

import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc.dart';

import 'package:fluxpay/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:fluxpay/features/settings/presentation/bloc/settings_event.dart';
import 'package:fluxpay/features/settings/presentation/bloc/settings_state.dart';

import 'package:fluxpay/features/splash/presentation/bloc/splash_bloc.dart';

import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';

import 'package:fluxpay/injection_container.dart';

class FluxPayApp extends StatefulWidget {
  const FluxPayApp({super.key});

  @override
  State<FluxPayApp> createState() => _FluxPayAppState();
}

class _FluxPayAppState extends State<FluxPayApp> {
  AppLifecycleHandler? _lifecycleHandler;

  bool _initializedLifecycle = false;

  @override
  void dispose() {
    _lifecycleHandler?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// ======================================================
        /// AUTH
        /// ======================================================
        BlocProvider<AuthBloc>(
          lazy: false,
          create: (_) => sl<AuthBloc>()..add(const CheckSessionRequested()),
        ),

        /// ======================================================
        /// APP LOCK
        /// ======================================================
        BlocProvider<AppLockBloc>(create: (_) => sl<AppLockBloc>()),

        /// ======================================================
        /// SPLASH
        /// ======================================================
        BlocProvider<SplashBloc>(create: (_) => sl<SplashBloc>()),

        /// ======================================================
        /// EXCHANGE
        /// ======================================================
        BlocProvider<ExchangeBloc>(create: (_) => sl<ExchangeBloc>()),

        /// ======================================================
        /// BENEFICIARIES
        /// ======================================================
        BlocProvider<BeneficiaryBloc>(create: (_) => sl<BeneficiaryBloc>()),

        /// ======================================================
        /// TRANSACTIONS
        /// ======================================================
        BlocProvider<TransactionBloc>(
          create: (_) => sl<TransactionBloc>()..add(const LoadTransactions()),
        ),

        /// ======================================================
        /// CONNECTIVITY
        /// ======================================================
        BlocProvider<ConnectivityCubit>(create: (_) => sl<ConnectivityCubit>()),

        /// ======================================================
        /// SETTINGS
        /// ======================================================
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>()..add(const LoadSettings()),
        ),
      ],

      child: Builder(
        builder: (context) {
          /// ======================================================
          /// INIT LIFECYCLE ONLY ONCE
          /// ======================================================

          if (!_initializedLifecycle) {
            _initializedLifecycle = true;

            _lifecycleHandler = AppLifecycleHandler(
              authBloc: context.read<AuthBloc>(),
            );

            _lifecycleHandler!.initialize();
          }

          return BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,

            listener: (context, state) {
              debugPrint('''
================ FLUXPAY APP ================
AUTH STATUS => ${state.status}
SESSION => ${state.session != null}
============================================
''');

              /// ======================================================
              /// LOCK APP
              /// ======================================================

              if (state.isLocked ||
                  state.requiresBiometric ||
                  state.requiresPin) {
                context.read<AppLockBloc>().add(const LockAppRequested());
              }

              /// ======================================================
              /// FORCE APP ROUTER REBUILD
              /// ======================================================

              if (state.status == AuthStatus.setupSecurity) {
                debugPrint('NAVIGATION TARGET => SECURITY SETUP');
              }

              if (state.status == AuthStatus.authenticated) {
                debugPrint('NAVIGATION TARGET => HOME');
              }

              if (state.status == AuthStatus.unauthenticated) {
                debugPrint('NAVIGATION TARGET => LOGIN');
              }
            },

            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                debugPrint('''
=========== THEME REBUILD ===========
IS DARK => ${settingsState.settings.isDarkMode}
THEME MODE => ${settingsState.themeMode}
====================================
''');

                return SessionWrapper(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      /// ======================================================
                      /// APP ROUTER NOW REBUILDS
                      /// WHEN AUTH STATE CHANGES
                      /// ======================================================

                      return MaterialApp(
                        title: 'FluxPay',

                        debugShowCheckedModeBanner: false,

                        theme: AppTheme.lightTheme,

                        darkTheme: AppTheme.darkTheme,

                        themeMode: settingsState.themeMode,

                        home: const AppRouter(),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
