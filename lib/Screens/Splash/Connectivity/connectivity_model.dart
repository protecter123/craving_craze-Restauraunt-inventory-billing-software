import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // For checking actual network access

class ConnectivityModel with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _hasInternet = false;

  ConnectivityModel() {
    // Check for connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      _checkInternetConnection();
    });

    // Perform an initial check when the model is created
    _checkInternetConnection();
  }

  bool get hasInternet => _hasInternet;

  // This method checks both the connectivity and actual network access
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      // Try to ping a reliable server like Google to check actual network access
      _hasInternet = await _isConnectedToInternet();
    }

    notifyListeners();
  }

  // Check if we can reach a known server
  Future<bool> _isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      print("Google.com lookup failed, trying another server...");
      // Try another server, e.g., Cloudflare DNS
      try {
        final result = await InternetAddress.lookup('cloudflare.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        print("Cloudflare.com lookup also failed.");
      }
    }
    return false;
  }
}
