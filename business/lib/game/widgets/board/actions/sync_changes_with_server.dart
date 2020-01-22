import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/repositories/game_repository.dart';

class SyncChangesWithServerAction extends ReduxAction<AppState> {
  SyncChangesWithServerAction();

  @override
  Future<AppState> reduce() async {
    await GameRepository.createOrUpdateGameSession(state.gameState.game);
    return null;
  }
}