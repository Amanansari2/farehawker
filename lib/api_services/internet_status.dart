import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_dialog.dart';

class InternetMonitorProvider extends ChangeNotifier {
  Timer? _timer;
  bool _dialogShown = false;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  void startMonitoring() {
    _timer ??= Timer.periodic(const Duration(seconds: 10), (_) async {
      final connected = await _checkInternet();

      if (connected != _isConnected) {
        _isConnected = connected;
        notifyListeners();
      }

      if (!connected && !_dialogShown && Get.context != null) {
        _dialogShown = true;
        _showNoInternetDialog();
      } else if (connected && _dialogShown) {
        if (Get.isDialogOpen ?? false) Get.back();
        _dialogShown = false;
      }
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => CustomDialogBox(
        title: "No Internet",
        descriptions: "You are not connected to the Internet. Please check your connection!",
        text: "OK",
        functionCall: () {
          if (Get.isDialogOpen ?? false) Get.back();
          _dialogShown = false;
        },
        titleColor: Colors.red,
        img: "assets/icons/warning.png",
      ),
    );
  }
}
