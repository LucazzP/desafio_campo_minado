import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/models/game_model.dart';
import 'package:business/game/repositories/game_repository.dart';

StreamSubscription _subscription;

class SyncServerAction extends ReduxAction<AppState> {
  final String gameCode;

  SyncServerAction({this.gameCode});

  @override
  AppState reduce() {
    if (_subscription != null) _subscription.cancel();
    _subscription = GameRepository.streamGame(gameCode).listen((game) {
      if (gameCode != null) {
        if (game.gameCode == state.gameState.game.gameCode) {
          dispatch(_ChangeGameModelWithoutServerAction(newGameModel: game));
        } else
          _subscription.cancel();
      }
    });
    return null;
  }
}

class _ChangeGameModelWithoutServerAction extends ReduxAction<AppState> {
  final GameModel newGameModel;

  _ChangeGameModelWithoutServerAction({this.newGameModel}) : assert(newGameModel != null);

  @override
  Future<AppState> reduce() async {
    if (state.gameState.game != newGameModel &&
        newGameModel.gameCode != null) {
      return state.copyWith(
          gameState: state.gameState.copyWith(game: newGameModel));
    } else
      return null;
  }
}