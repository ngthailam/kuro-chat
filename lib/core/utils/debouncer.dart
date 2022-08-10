import 'dart:async';

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({this.duration = const Duration(milliseconds: 350)});

  run(Function action) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      action();
    });
  }

  dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
