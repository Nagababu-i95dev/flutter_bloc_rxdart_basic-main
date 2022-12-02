import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityBloc {
  final Connectivity _connectivity = Connectivity();

  //seedValue :ConnectionStatus.online
  // Default will be offline. This controller will help to emit new states when the connection changes.
  final _controller = BehaviorSubject<ConnectivityResult>.seeded(ConnectivityResult.none);
  StreamSubscription? _connectionSubscription;

  checkInternetConnection() {
    _checkInternetConnection();
  }

  // The [ConnectionStatusValueNotifier] will subscribe to this
  // stream and everytime the connection status change it
  // will update it's value
  Stream<ConnectivityResult> get internetStatus => _controller.stream;

  Future<void> _checkInternetConnection()
  async {
      // This 2 seconds delay will give some time to the device to connect to the internet in order to avoid false-positives
      await Future.delayed(const Duration(seconds: 2));
      await _connectivity.onConnectivityChanged.listen((connectivityResult)
        async {
          try {
              _controller.sink.add(connectivityResult);
          }
          on SocketException catch (_) {
            _controller.sink.add(ConnectivityResult.none);
          }
      });
  }

  Future<void> close() async {
    // Cancel subscription and close controller
    await _connectionSubscription?.cancel();
    await _controller.close();
  }
}

final connectivityBloc = ConnectivityBloc();
