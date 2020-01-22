import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/actions/game_actions.dart';
import 'package:business/game/widgets/board/actions/board_actions.dart';
import 'package:business/game/widgets/board/models/status_game_enum.dart';
import 'package:business/game/widgets/score/actions/score_actions.dart';
import 'package:business/game/widgets/square/models/square_state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BoardViewModel extends BaseModel<AppState> {
  final List<List<SquareState>> listStates;
  final List<List<bool>> listBombs;
  final int rows;
  final int cols;
  final int flags;
  final bool isAlive;
  final bool victory;

  BoardViewModel({this.listStates, this.cols, this.rows, this.listBombs, this.flags, this.isAlive, this.victory}) : super(equals: [listStates, cols, rows, listBombs, flags, isAlive, victory]);

  void _lose() {
    dispatch(LoseGameAction(game: state.gameState.game));
  }

  void _win() {
    dispatch(WinGameAction(game: state.gameState.game));
  }

  void resetGame(bool newGame) {
    dispatch(
      ResetGameAction(
        newGame: newGame,
        bombs: state.gameState.game.bombs,
        lastGame: state.gameState.game,
      ),
    );
  }

  void probePress(int y, int x) {
    if (!isAlive) return;
    final SquareState _state = listStates[y][x];
    if (_state == SquareState.flag) return;
    if (listBombs[y][x]) {
      _changeSquareState(y, x, SquareState.pressed);
      _lose();
    } else {
      _pressSquare(y, x);
      dispatchFuture(SyncChangesWithServerAction());
      dispatch(StartTimerAction());
    }
  }

  void _pressSquare(int y, int x) {
    if (!_isValidPosition(y, x)) return;
    SquareState _state = listStates[y][x];
    if (_state == SquareState.pressed) return;
    _changeSquareState(y, x, SquareState.pressed);

    if (sideBombs(y, x) > 0) return;

    _pressSquare(y - 1, x);
    _pressSquare(y + 1, x);
    _pressSquare(y, x - 1);
    _pressSquare(y, x + 1);
    _pressSquare(y - 1, x - 1);
    _pressSquare(y + 1, x + 1);
    _pressSquare(y + 1, x - 1);
    _pressSquare(y - 1, x + 1);
  }

  void flag(int y, int x) {
    if (!isAlive) return;
    SquareState _state = listStates[y][x];
    if (_state == SquareState.flag) {
      _changeSquareState(y, x, SquareState.released);
      dispatch(AddFlagAction());
    } else {
      _changeSquareState(y, x, SquareState.flag);
      dispatch(RemoveFlagAction());
    }
    _verifyIfWon();
  }

  void _changeSquareState(int y, int x, SquareState state){
    List<List<SquareState>> _list = List.from(listStates);
    _list[y][x] = state;
    dispatch(ChangeSquareStateListAction(listStates: _list));
  }

  _verifyIfWon(){
    if(state.gameState.game.flags <= 0){
      bool won = true;
      for (var row = 0; row < listStates.length; row++) {
        for (var col = 0; col < listStates[row].length; col++) {
          if(listBombs[row][col] && listStates[row][col] != SquareState.flag) won = false;
        }
      }
      if(won) _win();
    }
    
  }

  int sideBombs(int y, int x) {
    int count = 0;
    count += _bombs(y - 1, x);
    count += _bombs(y + 1, x);
    count += _bombs(y, x - 1);
    count += _bombs(y, x + 1);
    count += _bombs(y - 1, x - 1);
    count += _bombs(y + 1, x + 1);
    count += _bombs(y + 1, x - 1);
    count += _bombs(y - 1, x + 1);
    return count;
  }

  int _bombs(int y, int x) {
    if (_isValidPosition(y, x)) {
      if (listBombs[y][x]) {
        return 1;
      }
    }
    return 0;
  }

  bool _isValidPosition(int posY, int posX) {
    if (posX < 0 || posY < 0) return false;
    if(listBombs ==  null) return false;
    if (posY > (listBombs.length  - 1)) return false;
    if (posX > (listBombs[posY].length  - 1)) return false;
    return true;
  }
  
  @override
  BaseModel fromStore() => BoardViewModel(
    listStates: state.gameState.game.listStates,
    listBombs: state.gameState.game.listBombs,
    rows: state.gameState.game.rows,
    cols: state.gameState.game.cols,
    flags: state.gameState.game.flags,
    isAlive: state.gameState.statusGame == StatusGame.running,
    victory: state.gameState.statusGame == StatusGame.won
  );
}