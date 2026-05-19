import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_event.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_state.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  final AuthBloc authBloc;

  AppLifecycleHandler({required this.authBloc});

  Timer? _backgroundTimer;

  bool _isLocked = false;

  /// =====================================================
  /// INIT
  /// =====================================================

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// =====================================================
  /// DISPOSE
  /// =====================================================

  void dispose() {
    _backgroundTimer?.cancel();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// =====================================================
    /// APP MOVED TO BACKGROUND
    /// DO NOT LOCK IMMEDIATELY
    /// =====================================================

    if (state == AppLifecycleState.paused) {
      _backgroundTimer?.cancel();

      _backgroundTimer = Timer(const Duration(seconds: 1), () {
        final currentState = authBloc.state;

        final shouldLock =
            currentState.status == AuthStatus.authenticated &&
            currentState.hasSecurityEnabled &&
            !_isLocked;

        if (shouldLock) {
          _isLocked = true;

          authBloc.add(const LockAppRequested());
        }
      });
    }

    /// =====================================================
    /// APP RESUMED
    /// CANCEL LOCK TIMER
    /// =====================================================

    if (state == AppLifecycleState.resumed) {
      _backgroundTimer?.cancel();

      _isLocked = false;
    }
  }
}
