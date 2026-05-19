import 'package:equatable/equatable.dart';

enum AppLockStatus { initial, locked, loading, unlocked, failure }

class AppLockState extends Equatable {
  final AppLockStatus status;

  final String? errorMessage;

  /// =====================================================
  /// LOCK FLAG
  /// =====================================================

  final bool isLocked;

  const AppLockState({
    this.status = AppLockStatus.initial,
    this.errorMessage,
    this.isLocked = false,
  });

  AppLockState copyWith({
    AppLockStatus? status,
    String? errorMessage,
    bool? isLocked,
    bool clearError = false,
  }) {
    return AppLockState(
      status: status ?? this.status,

      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),

      isLocked: isLocked ?? this.isLocked,
    );
  }

  /// =====================================================
  /// HELPERS
  /// =====================================================

  bool get isLoading => status == AppLockStatus.loading;

  bool get isUnlocked => status == AppLockStatus.unlocked;

  bool get hasError => status == AppLockStatus.failure;

  bool get isAppLocked => status == AppLockStatus.locked || isLocked;

  /// =====================================================
  /// INITIAL
  /// =====================================================

  factory AppLockState.initial() {
    return const AppLockState(status: AppLockStatus.initial, isLocked: false);
  }

  @override
  List<Object?> get props => [status, errorMessage, isLocked];
}
