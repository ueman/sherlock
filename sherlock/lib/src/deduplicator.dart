import 'dart:collection';

import 'package:sherlock/src/report.dart';

class Deduplicator {
  final Queue<int> _exceptionsToDeduplicate = Queue<int>();
  final _duplicatesCount = 10;

  bool isDuplicate(ErrorReport e) {
    final exceptionHashCode = e.hashCode;

    if (_exceptionsToDeduplicate.contains(exceptionHashCode)) {
      return true;
    }

    _exceptionsToDeduplicate.add(exceptionHashCode);
    if (_exceptionsToDeduplicate.length > _duplicatesCount) {
      _exceptionsToDeduplicate.removeFirst();
    }
    return false;
  }
}
