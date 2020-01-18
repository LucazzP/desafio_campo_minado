import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/app/redux/states.dart';
import 'package:desafio_campo_minado/src/modules/game/redux/game_actions.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/board/board_actions.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/score/score_actions.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/square/square_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum StatusGame {
  running,
  won,
  lose
}

class BoardViewModel extends BaseModel<AppState> {
  final List<List<SquareState>> listStates;
  final List<List<bool>> listBombs;
  final int rows;
  final int cols;
  final int flags;
  final bool isAlive;
  final StatusGame statusGame;
  Store<AppState> get store => States.store;

  BoardViewModel({this.listStates, this.cols, this.rows, this.listBombs, this.flags, this.isAlive, this.statusGame}) : super(equals: [listStates, cols, rows, listBombs, flags, isAlive, statusGame]);

  void _lose() {
    store.dispatch(LoseGameAction(game: States.gameState.game));
  }

  void _win() {
    store.dispatch(WinGameAction(game: States.gameState.game));
  }

  void resetGame(bool newGame) {
    store.dispatch(
      ResetGameAction(
        newGame: newGame,
        bombs: States.gameState.game.bombs,
        lastGame: States.gameState.game,
      ),
    );
  }

  void _probePress(int y, int x) {
    if (!isAlive) return;
    final SquareState _state = listStates[y][x];
    if (_state == SquareState.flag) return;
    if (listBombs[y][x]) {
      _changeSquareState(y, x, SquareState.pressed);
      _lose();
    } else {
      _pressSquare(y, x);
      store.dispatchFuture(SyncChangesWithServerAction());
      store.dispatch(StartTimerAction());
    }
  }

  void _pressSquare(int y, int x) {
    if (!_isValidPosition(y, x)) return;
    SquareState _state = listStates[y][x];
    if (_state == SquareState.pressed) return;
    _changeSquareState(y, x, SquareState.pressed);

    if (_sideBombs(y, x) > 0) return;

    _pressSquare(y - 1, x);
    _pressSquare(y + 1, x);
    _pressSquare(y, x - 1);
    _pressSquare(y, x + 1);
    _pressSquare(y - 1, x - 1);
    _pressSquare(y + 1, x + 1);
    _pressSquare(y + 1, x - 1);
    _pressSquare(y - 1, x + 1);
  }

  void _flag(int y, int x) {
    if (!isAlive) return;
    SquareState _state = listStates[y][x];
    if (_state == SquareState.flag) {
      _changeSquareState(y, x, SquareState.released);
      store.dispatch(AddFlagAction());
    } else {
      _changeSquareState(y, x, SquareState.flag);
      store.dispatch(RemoveFlagAction());
    }
    _verifyIfWon();
  }

  void _changeSquareState(int y, int x, SquareState state){
    List<List<SquareState>> _list = List.from(listStates);
    _list[y][x] = state;
    store.dispatch(ChangeSquareStateListAction(listStates: _list));
  }

  _verifyIfWon(){
    if(store.state.gameState.game.flags <= 0){
      bool won = true;
      for (var row = 0; row < listStates.length; row++) {
        for (var col = 0; col < listStates[row].length; col++) {
          if(listBombs[row][col] && listStates[row][col] != SquareState.flag) won = false;
        }
      }
      if(won) _win();
    }
    
  }

  List<TableRow> generateTable() {
    return List.generate(
      rows,
      (heightRef) => TableRow(
        children: List.generate(
          cols,
          (widthRef) =>
              _createSquare(heightRef, widthRef),
        ),
      ),
    );
  }

  Widget _createSquare(int posY, int posX) =>
      SquareWidget(
        colorSwitch: (posX + posY).isOdd,
        posX: posX,
        posY: posY,
        bombProximity: _sideBombs(posY, posX),
        isBomb: listBombs[posY][posX],
        state: listStates[posY][posX],
        onTap: (isBomb, bombs) => this._probePress(posY, posX),
        onLongTap: (isBomb, bombs) => this._flag(posY, posX),
      );

  int _sideBombs(int y, int x) {
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
    statusGame: state.gameState.statusGame
  );
}