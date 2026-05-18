import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluxpay/features/exchange/data/datasource/exchange_localdatasource.dart';
import 'package:fluxpay/features/settings/data/datasource/settings_local_datasource.dart';
import 'package:fluxpay/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:fluxpay/features/settings/domain/repositories/settings_repository.dart';
import 'package:fluxpay/features/settings/presentation/bloc/settings_bloc.dart';

import 'package:get_it/get_it.dart';

import 'package:fluxpay/core/connectivity/connectivity_cubit.dart';

import 'package:fluxpay/core/network/dio_client.dart';
import 'package:fluxpay/core/network/token_storage.dart';

import 'package:fluxpay/core/services/connectivity_service.dart';
import 'package:fluxpay/core/services/exchange_calculator_service.dart';
import 'package:fluxpay/core/services/live_rate_simulation_service.dart';

/// EXCHANGE
import 'package:fluxpay/features/exchange/data/datasource/exchange_remote_datasource.dart';
import 'package:fluxpay/features/exchange/data/repositories/exchange_repository_impl.dart';

import 'package:fluxpay/features/exchange/domain/repositories/exchange_repository.dart';

import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_bloc.dart';

/// BENEFICIARIES
import 'package:fluxpay/features/beneficiaries/data/datasource/beneficiary_local_datasource.dart';

import 'package:fluxpay/features/beneficiaries/data/repositories/beneficiary_repository_impl.dart';

import 'package:fluxpay/features/beneficiaries/domain/repositories/beneficiary_repository.dart';

import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';

/// TRANSACTIONS
import 'package:fluxpay/features/transactions/data/datasource/transaction_local_datasource.dart';

import 'package:fluxpay/features/transactions/data/repositories/transaction_repository_impl.dart';

import 'package:fluxpay/features/transactions/domain/repositories/transaction_repository.dart';

import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';

/// ANALYTICS
import 'package:fluxpay/features/analytics/domain/services/analytics_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  /// =====================================================
  /// SECURE STORAGE
  /// =====================================================
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  /// =====================================================
  /// TOKEN STORAGE
  /// =====================================================
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(secureStorage: sl<FlutterSecureStorage>()),
  );

  /// =====================================================
  /// CORE NETWORK
  /// =====================================================
  sl.registerLazySingleton<DioClient>(
    () => DioClient(tokenStorage: sl<TokenStorage>()),
  );

  /// =====================================================
  /// CONNECTIVITY
  /// =====================================================
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(connectivity: sl<Connectivity>()),
  );

  sl.registerLazySingleton<ConnectivityCubit>(
    () => ConnectivityCubit(service: sl<ConnectivityService>()),
  );

  /// =====================================================
  /// SERVICES
  /// =====================================================
  sl.registerLazySingleton<ExchangeCalculatorService>(
    () => ExchangeCalculatorService(),
  );

  sl.registerLazySingleton<LiveRateSimulationService>(
    () => LiveRateSimulationService(),
  );

  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

  /// =====================================================
  /// EXCHANGE FEATURE
  /// =====================================================

  /// DATASOURCE
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

  /// DATASOURCE
  sl.registerLazySingleton<BeneficiaryLocalDataSource>(
    () => BeneficiaryLocalDataSourceImpl(),
  );

  /// REPOSITORY
  sl.registerLazySingleton<BeneficiaryRepository>(
    () => BeneficiaryRepositoryImpl(
      localDataSource: sl<BeneficiaryLocalDataSource>(),
    ),
  );

  /// BLOC
  sl.registerFactory<BeneficiaryBloc>(
    () => BeneficiaryBloc(repository: sl<BeneficiaryRepository>()),
  );

  /// =====================================================
  /// TRANSACTION FEATURE
  /// =====================================================

  /// DATASOURCE
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(),
  );

  /// REPOSITORY
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDataSource: sl<TransactionLocalDataSource>(),
    ),
  );

  /// BLOC
  sl.registerFactory<TransactionBloc>(
    () => TransactionBloc(repository: sl<TransactionRepository>()),
  );

  /// DATASOURCES
  sl.registerLazySingleton<ExchangeLocalDataSource>(
    () => ExchangeLocalDataSourceImpl(),
  );

  /// DATASOURCE
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(),
  );

  /// REPOSITORY
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  /// BLOC
  sl.registerFactory(() => SettingsBloc(repository: sl()));
}
