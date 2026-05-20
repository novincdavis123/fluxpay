import 'dart:async';

import 'package:flutter/material.dart';

class InactivityService {
  final Duration lockTimeout;

  final Duration sessionTimeout;

  final VoidCallback onLock;

  final VoidCallback onSessionExpired;

  Timer? _lockTimer;

  Timer? _sessionTimer;

  bool _isLocked = false;

  bool _sessionExpired = false;

  DateTime? _lastInteractionTime;

  InactivityService({
    required this.lockTimeout,
    required this.sessionTimeout,
    required this.onLock,
    required this.onSessionExpired,
  });

  /// =====================================================
  /// START
  /// =====================================================

  void start() {
    _sessionExpired = false;

    _isLocked = false;

    _lastInteractionTime = DateTime.now();

    _startLockTimer();

    _startSessionTimer();
  }

  /// =====================================================
  /// USER INTERACTION
  /// =====================================================

  void registerInteraction() {
    if (_sessionExpired) {
      return;
    }

    _lastInteractionTime = DateTime.now();

    _isLocked = false;

    _restartLockTimer();
  }

  /// =====================================================
  /// LOCK TIMER
  /// =====================================================

  void _startLockTimer() {
    _lockTimer?.cancel();

    _lockTimer = Timer(lockTimeout, () {
      if (_sessionExpired) {
        return;
      }

      final now = DateTime.now();

      final inactiveDuration = now.difference(_lastInteractionTime ?? now);

      if (inactiveDuration >= lockTimeout && !_isLocked) {
        _isLocked = true;

        onLock();
      }
    });
  }

  void _restartLockTimer() {
    _startLockTimer();
  }

  /// =====================================================
  /// SESSION TIMER
  /// ABSOLUTE INACTIVITY
  /// =====================================================

  void _startSessionTimer() {
    _sessionTimer?.cancel();

    _sessionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_sessionExpired) {
        timer.cancel();

        return;
      }

      final now = DateTime.now();

      final inactiveDuration = now.difference(_lastInteractionTime ?? now);

      if (inactiveDuration >= sessionTimeout) {
        _sessionExpired = true;

        timer.cancel();

        onSessionExpired();
      }
    });
  }

  /// =====================================================
  /// UNLOCK
  /// DOES NOT RESET SESSION TIMER
  /// =====================================================

  void unlock() {
    if (_sessionExpired) {
      return;
    }

    _isLocked = false;

    _restartLockTimer();
  }

  /// =====================================================
  /// RESET SESSION
  /// USE AFTER LOGIN
  /// =====================================================

  void resetSession() {
    _sessionExpired = false;

    _isLocked = false;

    _lastInteractionTime = DateTime.now();

    _startLockTimer();

    _startSessionTimer();
  }

  /// =====================================================
  /// DISPOSE
  /// =====================================================

  void dispose() {
    _lockTimer?.cancel();

    _sessionTimer?.cancel();
  }
}
