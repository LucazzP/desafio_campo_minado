import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class ScoreBloc extends Disposable {
  BehaviorSubject<int> flags = BehaviorSubject<int>();
  BehaviorSubject<int> secondsElapsed = BehaviorSubject<int>();
  Stopwatch _stopwatch = Stopwatch();

  void startTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (secondsElapsed.isClosed) {
          timer.cancel();
          return;
        }
        secondsElapsed.sink.add(secondsElapsed.value + 1);
        if (!_stopwatch.isRunning) timer.cancel();
      });
    }
  }

  void stopTimer() => _stopwatch.stop();
  void resetTimer() {
    _stopwatch.reset();
    secondsElapsed.sink.add(0);
  }

  void addFlag() => flags.sink.add(flags.value + 1);
  void removeFlag() => flags.sink.add(flags.value - 1);

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    flags.close();
    secondsElapsed.close();
    _stopwatch.stop();
  }
}
