import 'package:sherlock/src/log_entry.dart';

class ErrorReport {
  ErrorReport({
    required this.exception,
    required this.stackTrace,
    required this.uncaught,
    required this.envInfo,
    required this.appInfo,
    required this.log,
  });

  final Object exception;
  final StackTrace stackTrace;
  final bool uncaught;
  final Map<String, dynamic> envInfo;
  final Map<String, dynamic> appInfo;
  final List<LogEntry> log;
}
