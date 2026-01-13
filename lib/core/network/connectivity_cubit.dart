import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(ConnectivityInitial()) {
    _init();
  }

  void _init() {
    _subscription =
        _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _onConnectivityChanged(result);
  }

  /// Called when user presses "Обновить" button.
  /// Emits [RetryRequested] so pages can retry their failed requests.
  void requestRetry() {
    // Hide overlay first
    emit(RetryRequested());
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      emit(const ConnectivityChanged(ConnectivityStatus.disconnected));
    } else {
      emit(const ConnectivityChanged(ConnectivityStatus.connected));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
