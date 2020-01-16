import 'dart:async';

import 'package:desafio_campo_minado/app/modules/game/game_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class ScoreBloc extends Disposable {
  BehaviorSubject<int> flags = BehaviorSubject<int>();
  BehaviorSubject<int> secondsElapsed = BehaviorSubject<int>.seeded(0);
  GameBloc gameBloc = GameModule.to.get<GameBloc>();
  GameModel get game => gameBloc.game;
  Timer timer;

  ScoreBloc() {
    serverSync();
  }

  void serverSync() {
    gameBloc.gameOut.listen((_game) {
      if (!flags.isClosed) if (_game.flags != flags.value)
        flags.sink.add(_game.flags);
      if (!secondsElapsed.isClosed &&
          timer == null &&
          _game.initialTime != null) startTimer();
    });
  }

  void startTimer() {
    if (game.initialTime == null || timer == null) {
      if (game.initialTime == null)
        gameBloc.game = game.copyWith(initialTime: DateTime.now());
      timer = timerCallBack(Timer.periodic(
        Duration(seconds: 1), timerCallBack
      ));
    }
  }

  Timer timerCallBack(Timer timer) {
    if (secondsElapsed.isClosed) {
      timer.cancel();
      return timer;
    }
    secondsElapsed.sink
        .add(DateTime.now().difference(game.initialTime).inSeconds);
    if (!game.active) timer.cancel();
    return timer;
  }

  void resetTimer() {
    secondsElapsed.sink.add(0);
  }

  void addFlag() => flags.sink.add(flags.value + 1);
  void removeFlag() => flags.sink.add(flags.value - 1);

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    flags.close();
    secondsElapsed.close();
  }
}
