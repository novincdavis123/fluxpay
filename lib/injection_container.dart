import 'package:fluxpay/core/network/dio_client.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<DioClient>(() => DioClient());
}
