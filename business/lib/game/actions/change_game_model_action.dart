import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/models/game_model.dart';
import 'package:business/game/repositories/game_repository.dart';

class ChangeGameModelAction extends ReduxAction<AppState> {
  final GameModel newGameModel;

  ChangeGameModelAction({this.newGameModel}) : assert(newGameModel != null);

  @override
  Future<AppState> reduce() async {
    if (state.gameState.game != newGameModel &&
        newGameModel.gameCode != null) {
      await GameRepository.createOrUpdateGameSession(newGameModel);
      return state.copyWith(
          gameState: state.gameState.copyWith(game: newGameModel));
    } else
      return null;
  }
}