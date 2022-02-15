import 'goxlr/exception.dart';
import 'goxlr/goxlr.dart';

class GoXLRManager {
  GoXLR? _goXLR;

  GoXLR get goXLR {
    var goXLR = _goXLR;
    if (goXLR == null) throw GoXLRUnavailable();
    return goXLR;
  }

  void set(GoXLR goXLR) {
    _goXLR = goXLR;
  }

  void remove() {
    _goXLR = null;
  }
}
