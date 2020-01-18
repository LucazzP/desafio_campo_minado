import 'dart:async';
import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/app/redux/states.dart';
import 'package:desafio_campo_minado/src/modules/game/game_module.dart';
import 'package:desafio_campo_minado/src/modules/game/game_repository.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/board/board_view_model.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/score/score_actions.dart';
import 'package:desafio_campo_minado/src/shared/models/game_model.dart';
import 'package:flutter/foundation.dart';
import 'package:random_string/random_string.dart';

GameRepository get _repo => GameModule.to.get<GameRepository>();
StreamSubscription _subscription;

class SyncServerAction extends ReduxAction<AppState> {
  final String gameCode;

  SyncServerAction({this.gameCode});

  @override
  AppState reduce() {
    if (_subscription != null) _subscription.cancel();
    _subscription = _repo.streamGame(gameCode).listen((game) {
      if (gameCode != null) {
        if (game.gameCode == States.gameState.game.gameCode) {
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
    if (States.gameState.game != newGameModel &&
        newGameModel.gameCode != null) {
      return state.copyWith(
          gameState: state.gameState.copyWith(game: newGameModel));
    } else
      return null;
  }
}

class ChangeGameModelAction extends ReduxAction<AppState> {
  final GameModel newGameModel;

  ChangeGameModelAction({this.newGameModel}) : assert(newGameModel != null);

  @override
  Future<AppState> reduce() async {
    if (States.gameState.game != newGameModel &&
        newGameModel.gameCode != null) {
      await _repo.createOrUpdateGameSession(newGameModel);
      return state.copyWith(
          gameState: state.gameState.copyWith(game: newGameModel));
    } else
      return null;
  }
}

class ChangeStatusGameAction extends ReduxAction<AppState> {
  final StatusGame statusGame;

  ChangeStatusGameAction({this.statusGame}) : assert(statusGame != null);

  @override
  AppState reduce() {
    return state.copyWith(
        gameState: state.gameState.copyWith(statusGame: statusGame));
  }
}

class ResetGameAction extends ReduxAction<AppState> {
  final bool newGame;
  final int bombs;
  final GameModel lastGame;

  ResetGameAction(
      {this.newGame = true, @required this.bombs, @required this.lastGame});

  @override
  Future<AppState> reduce() async {
    if (lastGame.gameCode != null) _repo.deleteGame(lastGame.gameCode);
    if (newGame) {
      await dispatchFuture(CreateGameAction(
          bombs: bombs, cols: lastGame.cols, rows: lastGame.rows));
    }
    return null;
  }
}

class WinGameAction extends ReduxAction<AppState> {
  final GameModel game;

  WinGameAction({@required this.game});

  @override
  Future<AppState> reduce() async {
    dispatch(StopTimerAction());
    dispatch(ChangeStatusGameAction(statusGame: StatusGame.won));
    dispatch(ChangeGameModelAction(newGameModel: game.copyWith(active: false)));
    return null;
  }
}

class LoseGameAction extends ReduxAction<AppState> {
  final GameModel game;

  LoseGameAction({@required this.game});

  @override
  Future<AppState> reduce() async {
    dispatch(StopTimerAction());
    dispatch(ChangeStatusGameAction(statusGame: StatusGame.lose));
    dispatch(ChangeGameModelAction(newGameModel: game.copyWith(active: false)));
    return null;
  }
}

class CreateGameAction extends ReduxAction<AppState> {
  final int bombs;
  final int cols;
  final int rows;

  /// If the gameCode is provided, then will get the game
  final String gameCode;

  CreateGameAction({this.bombs, this.cols, this.rows, this.gameCode});

  List<List<bool>> _createRandomBombList(int bombs, int rows, int cols) {
    var bombList = List<List<bool>>.generate(rows, (row) {
      return List<bool>.filled(cols, false);
    });
    Random _random = Random();
    int remainingMines = bombs;
    while (remainingMines > 0) {
      int row = _random.nextInt(rows);
      int col = _random.nextInt(cols);
      if (!bombList[row][col]) {
        bombList[row][col] = true;
        remainingMines--;
      }
    }
    return bombList;
  }

  @override
  Future<AppState> reduce() async {
    GameModel _gameModel;
    if (gameCode == null) {
      _gameModel = GameModel(
          listBombs: _createRandomBombList(bombs, rows, cols),
          bombs: bombs,
          gameCode: randomString(6, from: 65, to: 90));
    } else
      _gameModel = await _repo.getGame(gameCode);
    dispatch(ChangeGameModelAction(newGameModel: _gameModel));
    dispatch(SyncServerAction(gameCode: _gameModel.gameCode));
    dispatch(ChangeStatusGameAction(statusGame: StatusGame.running));
    return null;
  }
}
