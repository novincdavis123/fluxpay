import 'package:flutter/foundation.dart';

import 'package:fluxpay/core/errors/exceptions.dart';
import 'package:fluxpay/core/errors/failures.dart';
import 'package:fluxpay/features/exchange/data/datasource/exchange_localdatasource.dart';

import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/repositories/exchange_repository.dart';

import '../datasource/exchange_remote_datasource.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;

  final ExchangeLocalDataSource localDataSource;

  ExchangeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ExchangeRateEntity> getExchangeRate({
    required String from,
    required String to,
  }) async {
    try {
      /// FETCH REMOTE
      final remoteModel = await remoteDataSource.getExchangeRate(
        from: from,
        to: to,
      );

      /// CACHE OFFLINE
      await localDataSource.cacheExchangeRate(remoteModel);

      if (kDebugMode) {
        debugPrint('✅ Remote exchange rate fetched & cached');
      }

      return remoteModel.toEntity();
    }
    /// NETWORK FAILURE → FALLBACK TO CACHE
    on NetworkException catch (e) {
      if (kDebugMode) {
        debugPrint('🌐 Network Failure: ${e.message}');
        debugPrint('📦 Attempting offline cache fallback...');
      }

      try {
        final cachedModel = await localDataSource.getCachedExchangeRate(
          from: from,
          to: to,
        );

        if (cachedModel != null) {
          if (kDebugMode) {
            debugPrint('✅ Cached exchange rate loaded');
          }

          return cachedModel.toEntity();
        }

        throw NetworkFailure(
          'No internet connection and no cached exchange rate available',
        );
      } catch (_) {
        throw NetworkFailure(
          'No internet connection and offline cache unavailable',
        );
      }
    }
    /// AUTH FAILURE
    on UnauthorizedException catch (e) {
      if (kDebugMode) {
        debugPrint('🔐 Auth Failure: ${e.message}');
      }

      throw AuthFailure(e.message);
    }
    /// VALIDATION FAILURE
    on ValidationException catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Validation Failure: ${e.message}');
      }

      throw ValidationFailure(e.message);
    }
    /// SERVER FAILURE
    on ServerException catch (e) {
      if (kDebugMode) {
        debugPrint('🔥 Server Failure: ${e.message}');
      }

      /// TRY CACHE AS SECONDARY FALLBACK
      try {
        final cachedModel = await localDataSource.getCachedExchangeRate(
          from: from,
          to: to,
        );

        if (cachedModel != null) {
          if (kDebugMode) {
            debugPrint('📦 Loaded cached rate after server failure');
          }

          return cachedModel.toEntity();
        }
      } catch (_) {}

      throw ServerFailure(e.message);
    }
    /// UNKNOWN FAILURE
    on UnknownException catch (e) {
      if (kDebugMode) {
        debugPrint('❓ Unknown Failure: ${e.message}');
      }

      throw UnknownFailure(e.message);
    }
    /// FALLBACK
    catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Unexpected Repository Error: $e');
      }

      throw const UnknownFailure('Unexpected repository error occurred');
    }
  }
}
