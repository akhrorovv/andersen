import 'package:equatable/equatable.dart';

enum ConnectivityStatus { connected, disconnected, unknown }

sealed class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object?> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityChanged extends ConnectivityState {
  final ConnectivityStatus status;

  const ConnectivityChanged(this.status);

  bool get isConnected => status == ConnectivityStatus.connected;
  bool get isDisconnected => status == ConnectivityStatus.disconnected;

  @override
  List<Object?> get props => [status];
}

/// Emitted when user requests a retry (e.g., pressing "Обновить" button).
/// Pages should listen for this state and retry their failed requests.
class RetryRequested extends ConnectivityState {
  final DateTime timestamp;

  RetryRequested() : timestamp = DateTime.now();

  @override
  List<Object?> get props => [timestamp];
}
