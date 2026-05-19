import 'package:local_auth/local_auth.dart';

abstract class BiometricDataSource {
  Future<bool> authenticate();
}

class BiometricDataSourceImpl implements BiometricDataSource {
  final LocalAuthentication localAuth;

  const BiometricDataSourceImpl(this.localAuth);

  @override
  Future<bool> authenticate() async {
    try {
      final canCheck = await localAuth.canCheckBiometrics;

      final isSupported = await localAuth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        return false;
      }

      return await localAuth.authenticate(
        localizedReason: 'Authenticate to access FluxPay',

        biometricOnly: true,

        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
