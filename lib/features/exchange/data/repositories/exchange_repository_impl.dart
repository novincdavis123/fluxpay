import '../../domain/entities/exchange_rate_entity.dart';

import '../../domain/repositories/exchange_repository.dart';

import '../datasource/exchange_remote_datasource.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;

  ExchangeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ExchangeRateEntity> getExchangeRate({
    required String from,
    required String to,
  }) async {
    final model = await remoteDataSource.getExchangeRate(from: from, to: to);

    return model.toEntity();
  }
}
