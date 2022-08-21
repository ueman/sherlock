import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sherlock/src/client.dart';
import 'package:sherlock/src/deduplicator.dart';
import 'package:sherlock/src/log_entry.dart';
import 'package:sherlock/src/report.dart';
import 'package:sherlock/src/utils/package_info_x.dart';

class Sherlock {
  static final List<LogEntry> _logs = [];
  static late Client _client;
  static bool _initialized = false;
  static final _deduplicator = Deduplicator();
  static bool Function(ErrorReport) shouldReport = (report) {
    return true;
  };

  // Disable instanciation
  Sherlock._();

  static void initialize({Client? client}) {
    _client = client ?? Client();
    _hookPlatformDispatcherOnError();
    _hookFlutterErrorOnError();
    _initialized = true;
  }

  static Future<void> capture(
    Object exception,
    StackTrace stackTrace, {
    bool uncaught = false,
  }) async {
    if (_initialized) return;

    final app = await PackageInfo.fromPlatform();
    final device = await DeviceInfoPlugin().deviceInfo;
    final report = ErrorReport(
      appInfo: app.toMap(),
      envInfo: device.toMap(),
      log: _logs,
      exception: exception,
      stackTrace: stackTrace,
      uncaught: uncaught,
    );
    if (_deduplicator.isDuplicate(report)) {
      return;
    }

    if (shouldReport(report)) {
      return;
    }

    _client.sendToBackend(report);
  }

  static void log(
    String message, {
    Map<String, dynamic>? extra,
  }) {
    if (_initialized) return;
    _logs.add(LogEntry(message, extra));
  }

  static void _hookFlutterErrorOnError() {
    FlutterError.onError = (details) {
      capture(
        details.exception,
        details.stack ?? StackTrace.current,
        uncaught: true,
      );
    };
  }

  static void _hookPlatformDispatcherOnError() {
    WidgetsFlutterBinding.ensureInitialized().platformDispatcher.onError =
        (exception, stackTrace) {
      capture(exception, stackTrace, uncaught: true);
      return false;
    };
  }
}
