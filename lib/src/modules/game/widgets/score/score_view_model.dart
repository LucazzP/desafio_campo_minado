import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';

class ScoreViewModel extends BaseModel<AppState> {
  final int flags;
  final int secondsElapsed;

  ScoreViewModel({this.flags, this.secondsElapsed}) : super(equals: [flags, secondsElapsed]);

  @override
  BaseModel fromStore() => ScoreViewModel(
    flags: state.gameState.game.flags,
    secondsElapsed: state.gameState.secondsElapsed
  );
}
