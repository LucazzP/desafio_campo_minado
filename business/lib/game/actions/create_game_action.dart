import 'dart:async';
import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/actions/change_game_model_action.dart';
import 'package:business/game/actions/change_status_game_action.dart';
import 'package:business/game/actions/sync_server_action.dart';
import 'package:business/game/models/game_model.dart';
import 'package:business/game/repositories/game_repository.dart';
import 'package:business/game/widgets/board/models/status_game_enum.dart';
import 'package:random_string/random_string.dart';

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
      _gameModel = await GameRepository.getGame(gameCode);
    dispatch(ChangeGameModelAction(newGameModel: _gameModel));
    dispatch(SyncServerAction(gameCode: _gameModel.gameCode));
    dispatch(ChangeStatusGameAction(statusGame: StatusGame.running));
    return null;
  }
}