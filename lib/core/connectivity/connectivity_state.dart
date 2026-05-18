enum ConnectivityStatus { connected, disconnected }

class ConnectivityState {
  final ConnectivityStatus status;

  const ConnectivityState({required this.status});

  bool get isConnected => status == ConnectivityStatus.connected;

  bool get isDisconnected => status == ConnectivityStatus.disconnected;

  ConnectivityState copyWith({ConnectivityStatus? status}) {
    return ConnectivityState(status: status ?? this.status);
  }
}
