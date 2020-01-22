import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';

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