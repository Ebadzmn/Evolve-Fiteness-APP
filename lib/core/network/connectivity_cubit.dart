import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectivityStatus { connected, disconnected }

class ConnectivityState {
  final ConnectivityStatus status;
  final bool isDisconnected;

  const ConnectivityState({
    required this.status,
    required this.isDisconnected,
  });

  factory ConnectivityState.connected() => const ConnectivityState(
        status: ConnectivityStatus.connected,
        isDisconnected: false,
      );

  factory ConnectivityState.disconnected() => const ConnectivityState(
        status: ConnectivityStatus.disconnected,
        isDisconnected: true,
      );
}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(ConnectivityState.connected()) {
    _initConnectivity();
  }

  void _initConnectivity() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(results);
    } catch (_) {
      emit(ConnectivityState.disconnected());
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      emit(ConnectivityState.disconnected());
      return;
    }

    final hasInternet = await _checkRealInternetAccess();
    if (hasInternet) {
      emit(ConnectivityState.connected());
    } else {
      emit(ConnectivityState.disconnected());
    }
  }

  Future<bool> _checkRealInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
