import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/app/redux/states.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/board/board_view_model.dart';

class GameViewModel extends BaseModel<AppState> {
  final StatusGame statusGame;
  final bool ready;
  final String gameCode;
  Store<AppState> get store => States.store;

  GameViewModel({this.statusGame, this.ready, this.gameCode})
      : super(equals: [statusGame, ready, gameCode]);

  @override
  BaseModel fromStore() => GameViewModel(
        statusGame: state.gameState.statusGame,
        ready: state.gameState.game.listBombs != null,
        gameCode: state.gameState.game.gameCode,
      );
}
