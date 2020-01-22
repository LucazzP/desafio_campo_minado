import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/actions/create_game_action.dart';
import 'package:business/game/models/game_model.dart';
import 'package:business/game/repositories/game_repository.dart';

class ResetGameAction extends ReduxAction<AppState> {
  final bool newGame;
  final int bombs;
  final GameModel lastGame;

  ResetGameAction(
      {this.newGame = true, this.bombs, this.lastGame});

  @override
  Future<AppState> reduce() async {
    if (lastGame.gameCode != null) GameRepository.deleteGame(lastGame.gameCode);
    if (newGame) {
      await dispatchFuture(CreateGameAction(
          bombs: bombs, cols: lastGame.cols, rows: lastGame.rows));
    }
    return null;
  }
}