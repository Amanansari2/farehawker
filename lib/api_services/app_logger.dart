import 'package:flutter/foundation.dart';

class AppLogger {

  static void log(String message) {
    if (!kReleaseMode) {
      const int chunkSize = 800;
      for (int i = 0; i < message.length; i += chunkSize) {
        final int endIndex = (i + chunkSize < message.length)
            ? i + chunkSize
            : message.length;
        debugPrint(message.substring(i, endIndex));
      }
    }
  }
}