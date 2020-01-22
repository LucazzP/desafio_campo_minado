import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/actions/game_actions.dart';

Timer _timer;

class _UpdateSecondsAction extends ReduxAction<AppState> {
  _UpdateSecondsAction();

  @override
  AppState reduce() {
    if (state.gameState.game.active) {
      return state.copyWith(
          gameState: state.gameState.copyWith(
        secondsElapsed: DateTime.now()
            .difference(state.gameState.game?.initialTime ?? DateTime.now())
            .inSeconds,
      ));
    } else
      return null;
  }
}

class StartTimerAction extends ReduxAction<AppState> {
  StartTimerAction();

  Timer _timerCallBack(Timer timer) {
    dispatch(_UpdateSecondsAction());
    return timer;
  }

  @override
  AppState reduce() {
    if (state.gameState.game.initialTime == null || _timer == null) {
      if (state.gameState.game.initialTime == null) {
        dispatch(
          ChangeGameModelAction(
              newGameModel:
                  state.gameState.game.copyWith(initialTime: DateTime.now())),
        );
      }
      _timer =
          _timerCallBack(Timer.periodic(Duration(seconds: 1), _timerCallBack));
    }
    return null;
  }
}

class StopTimerAction extends ReduxAction<AppState> {
  StopTimerAction();

  @override
  AppState reduce() {
    _timer.cancel();
    _timer = null;
    return null;
  }
}

class AddFlagAction extends ReduxAction<AppState> {
  AddFlagAction();

  @override
  AppState reduce() {
    if (state.gameState.game.flags + 1 <= state.gameState.game.bombs)
      return state.copyWith(
        gameState: state.gameState.copyWith(
          game: state.gameState.game
              .copyWith(flags: state.gameState.game.flags + 1),
        ),
      );
    else
      return null;
  }
}

class RemoveFlagAction extends ReduxAction<AppState> {
  RemoveFlagAction();

  @override
  AppState reduce() {
    if (state.gameState.game.flags - 1 > 0)
      return state.copyWith(
        gameState: state.gameState.copyWith(
          game: state.gameState.game
              .copyWith(flags: state.gameState.game.flags - 1),
        ),
      );
    else
      return null;
  }
}
