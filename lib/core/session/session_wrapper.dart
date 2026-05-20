import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/core/session/inactivity_service.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_event.dart';
import 'package:fluxpay/features/auth/presentation/bloc/auth_state.dart';

class SessionWrapper extends StatefulWidget {
  final Widget child;

  const SessionWrapper({super.key, required this.child});

  @override
  State<SessionWrapper> createState() => _SessionWrapperState();
}

class _SessionWrapperState extends State<SessionWrapper> {
  late final InactivityService _inactivityService;

  @override
  void initState() {
    super.initState();

    _inactivityService = InactivityService(
      /// =====================================================
      /// 1 MINUTE SCREEN LOCK
      /// =====================================================
      lockTimeout: const Duration(minutes: 1),

      /// =====================================================
      /// 3 MINUTE SESSION LOGOUT
      /// =====================================================
      sessionTimeout: const Duration(minutes: 3),

      /// =====================================================
      /// LOCK CALLBACK
      /// =====================================================
      onLock: () {
        final authState = context.read<AuthBloc>().state;

        final shouldLock =
            authState.status == AuthStatus.authenticated &&
            authState.hasSecurityEnabled;

        if (shouldLock) {
          context.read<AuthBloc>().add(const LockAppRequested());
        }
      },

      /// =====================================================
      /// SESSION EXPIRED CALLBACK
      /// =====================================================
      onSessionExpired: () {
        context.read<AuthBloc>().add(const SessionExpiredLogoutRequested());
      },
    );

    _inactivityService.start();
  }

  @override
  void dispose() {
    _inactivityService.dispose();

    super.dispose();
  }

  /// =====================================================
  /// USER INTERACTION
  /// =====================================================

  void _onUserInteraction() {
    final authState = context.read<AuthBloc>().state;

    /// DO NOT RESET AFTER SESSION EXPIRED
    if (authState.status == AuthStatus.sessionExpired) {
      return;
    }

    _inactivityService.registerInteraction();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,

      onPointerDown: (_) => _onUserInteraction(),

      onPointerMove: (_) => _onUserInteraction(),

      onPointerSignal: (_) => _onUserInteraction(),

      child: widget.child,
    );
  }
}
