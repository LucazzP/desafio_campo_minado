import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/widgets/board/models/status_game_enum.dart';

class ChangeStatusGameAction extends ReduxAction<AppState> {
  final StatusGame statusGame;

  ChangeStatusGameAction({this.statusGame}) : assert(statusGame != null);

  @override
  AppState reduce() {
    return state.copyWith(
        gameState: state.gameState.copyWith(statusGame: statusGame));
  }
}