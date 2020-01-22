import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/widgets/square/models/square_state_enum.dart';

class ChangeSquareStateListAction extends ReduxAction<AppState> {
  final List<List<SquareState>> listStates;

  ChangeSquareStateListAction({this.listStates}) : assert(listStates != null);

  @override
  AppState reduce() {
    return state.copyWith(gameState: state.gameState.copyWith(game: state.gameState.game.copyWith(listStates: listStates)));
  }
}