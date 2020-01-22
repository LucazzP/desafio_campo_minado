import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';

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