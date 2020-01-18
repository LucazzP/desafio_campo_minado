import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/modules/game/game_module.dart';
import 'package:desafio_campo_minado/src/modules/game/game_repository.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/square/square_widget.dart';

class ChangeSquareStateListAction extends ReduxAction<AppState> {
  final List<List<SquareState>> listStates;

  ChangeSquareStateListAction({this.listStates}) : assert(listStates != null);

  @override
  AppState reduce() {
    return state.copyWith(gameState: state.gameState.copyWith(game: state.gameState.game.copyWith(listStates: listStates)));
  }
}

class SyncChangesWithServerAction extends ReduxAction<AppState> {
  SyncChangesWithServerAction();

  @override
  Future<AppState> reduce() async {
    await GameModule.to.get<GameRepository>().createOrUpdateGameSession(state.gameState.game);
    return null;
  }
}