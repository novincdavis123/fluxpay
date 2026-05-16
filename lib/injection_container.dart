import 'package:fluxpay/features/exchange/presentation/bloc/exchange_bloc/exchange_bloc.dart';
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

  sl.registerLazySingleton<ExchangeCalculatorService>(
    () => ExchangeCalculatorService(),
  );

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
}
