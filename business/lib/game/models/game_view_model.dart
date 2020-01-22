import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/widgets/board/models/status_game_enum.dart';

class GameViewModel extends BaseModel<AppState> {
  final StatusGame statusGame;
  final bool ready;
  final String gameCode;

  GameViewModel({this.statusGame, this.ready, this.gameCode})
      : super(equals: [statusGame, ready, gameCode]);

  @override
  BaseModel fromStore() => GameViewModel(
        statusGame: state.gameState.statusGame,
        ready: state.gameState.game.listBombs != null,
        gameCode: state.gameState.game.gameCode,
      );
}
