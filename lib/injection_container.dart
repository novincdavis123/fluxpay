import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get_it/get_it.dart';

import 'package:local_auth/local_auth.dart';

import 'package:fluxpay/core/connectivity/connectivity_cubit.dart';

import 'package:fluxpay/core/network/dio_client.dart';

import 'package:fluxpay/core/security/secure_storage_service.dart';

import 'package:fluxpay/core/services/connectivity_service.dart';
import 'package:fluxpay/core/services/exchange_calculator_service.dart';
import 'package:fluxpay/core/services/live_rate_simulation_service.dart';

import 'package:fluxpay/features/auth/data/datasource/auth_local_datasource.dart';

import 'package:fluxpay/features/auth/data/datasource/biometric_datasource.dart';

import 'package:fluxpay/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:fluxpay/features/auth/data/repositories/auth_security_repository_impl.dart';

import 'package:fluxpay/features/auth/domain/repositories/auth_repository.dart';

import 'package:fluxpay/features/auth/domain/repositories/auth_security_repository.dart';

import 'package:fluxpay/features/auth/domain/usecases/authenticate_biometric_usecase.dart';

import 'package:fluxpay/features/auth/domain/usecases/validate_session_usecase.dart';

import 'package:fluxpay/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:fluxpay/features/auth/presentation/bloc/app_lock_bloc.dart';

import 'package:fluxpay/features/exchange/data/datasource/exchange_localdatasource.dart';

import 'package:fluxpay/features/exchange/data/datasource/exchange_remote_datasource.dart';

import 'package:fluxpay/features/exchange/data/repositories/exchange_repository_impl.dart';

import 'package:fluxpay/features/exchange/domain/repositories/exchange_repository.dart';

import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc.dart';

import 'package:fluxpay/features/beneficiaries/data/datasource/beneficiary_local_datasource.dart';

import 'package:fluxpay/features/beneficiaries/data/repositories/beneficiary_repository_impl.dart';

import 'package:fluxpay/features/beneficiaries/domain/repositories/beneficiary_repository.dart';

import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';

import 'package:fluxpay/features/transactions/data/datasource/transaction_local_datasource.dart';

import 'package:fluxpay/features/transactions/data/repositories/transaction_repository_impl.dart';

import 'package:fluxpay/features/transactions/domain/repositories/transaction_repository.dart';

import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';

import 'package:fluxpay/features/analytics/domain/services/analytics_service.dart';

import 'package:fluxpay/features/settings/data/datasource/settings_local_datasource.dart';

import 'package:fluxpay/features/settings/data/repositories/settings_repository_impl.dart';

import 'package:fluxpay/features/settings/domain/repositories/settings_repository.dart';

import 'package:fluxpay/features/settings/presentation/bloc/settings_bloc.dart';

import 'package:fluxpay/features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  /// =====================================================
  /// EXTERNAL
  /// =====================================================

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());

  /// =====================================================
  /// CORE STORAGE & SECURITY
  /// =====================================================

  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  /// =====================================================
  /// NETWORK
  /// =====================================================

  sl.registerLazySingleton<DioClient>(() => DioClient());

  /// =====================================================
  /// CONNECTIVITY
  /// =====================================================

  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(connectivity: sl<Connectivity>()),
  );

  sl.registerLazySingleton<ConnectivityCubit>(
    () => ConnectivityCubit(service: sl<ConnectivityService>()),
  );

  /// =====================================================
  /// CORE SERVICES
  /// =====================================================

  sl.registerLazySingleton<ExchangeCalculatorService>(
    () => ExchangeCalculatorService(),
  );

  sl.registerLazySingleton<LiveRateSimulationService>(
    () => LiveRateSimulationService(),
  );

  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

  /// =====================================================
  /// AUTH FEATURE
  /// =====================================================

  /// AUTH LOCAL DATASOURCE
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sl<FlutterSecureStorage>(),
      sl<LocalAuthentication>(),
    ),
  );

  /// AUTH REPOSITORY
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl<AuthLocalDataSource>()),
  );

  /// VALIDATE SESSION USECASE
  sl.registerLazySingleton<ValidateSessionUseCase>(
    () => ValidateSessionUseCase(sl<AuthRepository>()),
  );

  /// AUTH BLOC
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(repository: sl<AuthRepository>()),
  );

  /// =====================================================
  /// BIOMETRIC / APP LOCK
  /// =====================================================

  /// BIOMETRIC DATASOURCE
  sl.registerLazySingleton<BiometricDataSource>(
    () => BiometricDataSourceImpl(sl<LocalAuthentication>()),
  );

  /// SECURITY REPOSITORY
  sl.registerLazySingleton<AuthSecurityRepository>(
    () => AuthSecurityRepositoryImpl(
      biometricDataSource: sl<BiometricDataSource>(),
    ),
  );

  /// BIOMETRIC USECASE
  sl.registerLazySingleton<AuthenticateBiometricUseCase>(
    () => AuthenticateBiometricUseCase(sl<AuthSecurityRepository>()),
  );

  /// APP LOCK BLOC
  sl.registerFactory<AppLockBloc>(
    () => AppLockBloc(
      biometricUseCase: sl<AuthenticateBiometricUseCase>(),
      authRepository: sl<AuthRepository>(),
    ),
  );

  /// =====================================================
  /// EXCHANGE FEATURE
  /// =====================================================

  /// LOCAL DATASOURCE
  sl.registerLazySingleton<ExchangeLocalDataSource>(
    () => ExchangeLocalDataSourceImpl(),
  );

  /// REMOTE DATASOURCE
  sl.registerLazySingleton<ExchangeRemoteDataSource>(
    () => ExchangeRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  /// REPOSITORY
  sl.registerLazySingleton<ExchangeRepository>(
    () => ExchangeRepositoryImpl(
      localDataSource: sl<ExchangeLocalDataSource>(),
      remoteDataSource: sl<ExchangeRemoteDataSource>(),
    ),
  );

  /// BLOC
  sl.registerFactory<ExchangeBloc>(
    () => ExchangeBloc(
      repository: sl<ExchangeRepository>(),
      calculatorService: sl<ExchangeCalculatorService>(),
      liveRateSimulationService: sl<LiveRateSimulationService>(),
    ),
  );

  /// =====================================================
  /// BENEFICIARY FEATURE
  /// =====================================================

  sl.registerLazySingleton<BeneficiaryLocalDataSource>(
    () => BeneficiaryLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<BeneficiaryRepository>(
    () => BeneficiaryRepositoryImpl(
      localDataSource: sl<BeneficiaryLocalDataSource>(),
    ),
  );

  sl.registerFactory<BeneficiaryBloc>(
    () => BeneficiaryBloc(repository: sl<BeneficiaryRepository>()),
  );

  /// =====================================================
  /// TRANSACTION FEATURE
  /// =====================================================

  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDataSource: sl<TransactionLocalDataSource>(),
    ),
  );

  sl.registerFactory<TransactionBloc>(
    () => TransactionBloc(repository: sl<TransactionRepository>()),
  );

  /// =====================================================
  /// SETTINGS FEATURE
  /// =====================================================

  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<SettingsRepository>(
    () =>
        SettingsRepositoryImpl(localDataSource: sl<SettingsLocalDataSource>()),
  );

  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(repository: sl<SettingsRepository>()),
  );

  /// =====================================================
  /// SPLASH FEATURE
  /// =====================================================

  sl.registerFactory<SplashBloc>(
    () => SplashBloc(sl<ValidateSessionUseCase>(), sl<AuthRepository>()),
  );
}
