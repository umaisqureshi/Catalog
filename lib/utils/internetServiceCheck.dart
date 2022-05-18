import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity/connectivity.dart';

class ConnectionStatus {
  static final ConnectionStatus _singleton = new ConnectionStatus._internal();
  ConnectionStatus._internal();

  static ConnectionStatus getInstance() => _singleton;

  bool isInternetAvailable = false;

  StreamController connectionChangeController = new StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = isInternetAvailable;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isInternetAvailable = true;
      } else {
        isInternetAvailable = false;
      }
    } on SocketException catch(_) {
      isInternetAvailable = false;
    }

    if (previousConnection != isInternetAvailable) {
      connectionChangeController.add(isInternetAvailable);
    }

    return isInternetAvailable;
  }
}