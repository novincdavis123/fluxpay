import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  ConnectivityService({required Connectivity connectivity})
    : _connectivity = connectivity;

  Stream<bool> get connectionStream => _controller.stream;

  Future<bool> checkConnection() async {
    return InternetConnection().hasInternetAccess;
  }

  Future<void> initialize() async {
    final initialConnection = await checkConnection();

    _controller.add(initialConnection);

    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      final hasConnection = await checkConnection();

      _controller.add(hasConnection);
    });
  }

  void dispose() {
    _subscription?.cancel();

    _controller.close();
  }
}
