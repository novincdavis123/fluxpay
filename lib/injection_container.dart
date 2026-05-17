import 'package:fluxpay/features/analytics/domain/services/analytics_service.dart';
import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_bloc.dart';
import 'package:fluxpay/features/transactions/data/datasource/transaction_local_datasource.dart';
import 'package:fluxpay/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:fluxpay/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:fluxpay/core/network/dio_client.dart';

import 'package:fluxpay/core/services/exchange_calculator_service.dart';
import 'package:fluxpay/core/services/live_rate_simulation_service.dart';

/// EXCHANGE
import 'package:fluxpay/features/exchange/data/datasource/exchange_remote_datasource.dart';

import 'package:fluxpay/features/exchange/data/repositories/exchange_repository_impl.dart';

import 'package:fluxpay/features/exchange/domain/repositories/exchange_repository.dart';

/// BENEFICIARIES
import 'package:fluxpay/features/beneficiaries/data/datasource/beneficiary_local_datasource.dart';

import 'package:fluxpay/features/beneficiaries/data/repositories/beneficiary_repository_impl.dart';

import 'package:fluxpay/features/beneficiaries/domain/repositories/beneficiary_repository.dart';

import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  /// CORE
  sl.registerLazySingleton<DioClient>(() => DioClient());

  /// EXCHANGE CALCULATOR SERVICE
  sl.registerLazySingleton<ExchangeCalculatorService>(
    () => ExchangeCalculatorService(),
  );

  /// LIVE RATE SIMULATION SERVICE
  sl.registerLazySingleton<LiveRateSimulationService>(
    () => LiveRateSimulationService(),
  );

  /// EXCHANGE DATASOURCE
  sl.registerLazySingleton<ExchangeRemoteDataSource>(
    () => ExchangeRemoteDataSourceImpl(dioClient: sl()),
  );

  /// EXCHANGE REPOSITORY
  sl.registerLazySingleton<ExchangeRepository>(
    () => ExchangeRepositoryImpl(remoteDataSource: sl()),
  );

  /// EXCHANGE BLOC
  sl.registerFactory(
    () => ExchangeBloc(
      repository: sl(),
      calculatorService: sl(),
      liveRateSimulationService: sl(),
    ),
  );

  /// BENEFICIARY DATASOURCE
  sl.registerLazySingleton<BeneficiaryLocalDataSource>(
    () => BeneficiaryLocalDataSourceImpl(),
  );

  /// BENEFICIARY REPOSITORY
  sl.registerLazySingleton<BeneficiaryRepository>(
    () => BeneficiaryRepositoryImpl(localDataSource: sl()),
  );

  /// BENEFICIARY BLOC
  sl.registerFactory(() => BeneficiaryBloc(repository: sl()));

  /// TRANSACTION DATASOURCE
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(),
  );

  /// TRANSACTION REPOSITORY
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(localDataSource: sl()),
  );

  /// TRANSACTION BLOC
  sl.registerFactory(() => TransactionBloc(repository: sl()));

  /// ANALYTICS SERVICE
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
}
