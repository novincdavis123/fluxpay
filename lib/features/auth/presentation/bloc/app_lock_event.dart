import 'package:equatable/equatable.dart';

abstract class AppLockEvent extends Equatable {
  const AppLockEvent();

  @override
  List<Object?> get props => [];
}

/// =====================================================
/// UNLOCK USING BIOMETRIC
/// =====================================================

class UnlockWithBiometric extends AppLockEvent {
  const UnlockWithBiometric();
}

/// =====================================================
/// UNLOCK USING PIN
/// =====================================================

class UnlockWithPin extends AppLockEvent {
  final String pin;

  const UnlockWithPin(this.pin);

  @override
  List<Object?> get props => [pin];
}

/// =====================================================
/// LOCK APP
/// =====================================================

class LockAppRequested extends AppLockEvent {
  const LockAppRequested();
}

/// =====================================================
/// RESET LOCK STATE
/// =====================================================

class ResetLockStateRequested extends AppLockEvent {
  const ResetLockStateRequested();
}
