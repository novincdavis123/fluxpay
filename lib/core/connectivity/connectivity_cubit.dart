import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'connectivity_state.dart';

import '../services/connectivity_service.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService service;

  StreamSubscription<bool>? _subscription;

  ConnectivityCubit({required this.service})
    : super(const ConnectivityState(status: ConnectivityStatus.connected)) {
    _initialize();
  }

  /// INITIALIZATION
  Future<void> _initialize() async {
    final isConnected = await service.checkConnection();

    emit(
      ConnectivityState(
        status: isConnected
            ? ConnectivityStatus.connected
            : ConnectivityStatus.disconnected,
      ),
    );

    _subscription = service.connectionStream.listen((isConnected) {
      emit(
        ConnectivityState(
          status: isConnected
              ? ConnectivityStatus.connected
              : ConnectivityStatus.disconnected,
        ),
      );
    });

    await service.initialize();
  }

  /// MANUAL RETRY
  Future<void> checkConnection() async {
    final isConnected = await service.checkConnection();

    emit(
      ConnectivityState(
        status: isConnected
            ? ConnectivityStatus.connected
            : ConnectivityStatus.disconnected,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();

    return super.close();
  }
}
