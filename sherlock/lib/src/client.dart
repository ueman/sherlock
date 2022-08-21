import 'dart:developer';

import 'package:sherlock/src/report.dart';

class Client {
  Future<void> sendToBackend(ErrorReport report) async {
    log(report.toString());
  }
}
