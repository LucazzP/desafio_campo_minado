import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/actions/change_game_model_action.dart';
import 'package:business/game/actions/change_status_game_action.dart';
import 'package:business/game/models/game_model.dart';
import 'package:business/game/widgets/board/models/status_game_enum.dart';
import 'package:business/game/widgets/score/actions/start_stop_timer_action.dart';

class WinGameAction extends ReduxAction<AppState> {
  final GameModel game;

  WinGameAction(this.game);

  @override
  Future<AppState> reduce() async {
    dispatch(StopTimerAction());
    dispatch(ChangeStatusGameAction(statusGame: StatusGame.won));
    dispatch(ChangeGameModelAction(newGameModel: game.copyWith(active: false)));
    return null;
  }
}