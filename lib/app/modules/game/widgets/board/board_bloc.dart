import 'package:desafio_campo_minado/app/modules/game/game_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class BoardBloc extends Disposable {
  final Function(GameModel newGame) updateDataServer;
  final Stream<GameModel> stream;
  final GameModel Function() getGame;
  final bool Function() _isAlive;
  final Function lose;
  final Function win;
  var listTableRows = BehaviorSubject<List<TableRow>>();
  ScoreBloc scoreBloc = GameModule.to.get<ScoreBloc>();
  bool get isAlive => _isAlive();
  GameModel get game => getGame();

  BoardBloc(this.updateDataServer, this.stream, this.getGame, this._isAlive, this.lose, this.win) {
    resetBoard();
    serverSync();
    _verifyChanges(game);
  }

  void resetBoard(){
    listTableRows.sink.add(_generateTable(game));
  }

  void serverSync(){
    stream.listen((_game) => _verifyChanges(_game));
  }

  void _verifyChanges(GameModel _game){
    listTableRows.value.forEach((tableRow){
      tableRow.children.forEach((square){
        SquareWidget squareWidget = square as SquareWidget;
        if(_game.listBombs != null) if(squareWidget.isBomb != _game.listBombs[squareWidget.posY][squareWidget.posX]) resetBoard();
        if(squareWidget.state != _game.listStates[squareWidget.posY][squareWidget.posX]){
          squareWidget.sinkState.add(_game.listStates[squareWidget.posY][squareWidget.posX]);
        }
      });
    });
  }

  void _probePress(int y, int x) {
    if (!isAlive) return;
    SquareWidget square = _pickSquareFromList(y, x);
    if (square.state == SquareState.flag) return;
    if (game.listBombs[y][x]) {
      _changeSquareState(square, SquareState.pressed);
      lose();
    } else {
      _pressSquare(y, x);
      scoreBloc.startTimer();
      updateDataServer(game);
    }
  }

  void _pressSquare(int y, int x) {
    if (!_isValidPosition(y, x)) return;
    SquareWidget square = _pickSquareFromList(y, x);
    if (square.state == SquareState.pressed) return;
    _changeSquareState(square, SquareState.pressed);

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
    SquareWidget square = _pickSquareFromList(y, x);
    if (square.state == SquareState.flag) {
      _changeSquareState(square, SquareState.released);
      game.flags++;
    } else {
      _changeSquareState(square, SquareState.flag);
      game.flags--;
    }
    updateDataServer(game);
    _verifyIfWon();
  }

  void _changeSquareState(SquareWidget square, SquareState state){
    square.sinkState.add(state);
    game.listStates[square.posY][square.posX] = state;
  }

  _verifyIfWon(){
    if(scoreBloc.flags.value == 0){
      bool won = true;
      listTableRows.value.forEach((tableRow){
        tableRow.children.forEach((square){
          SquareWidget squareWidget = (square as SquareWidget);
          if(squareWidget.isBomb && squareWidget.state != SquareState.flag) won = false;
        });
      });
      if(won) win();
    }
    
  }

  int _sideBombs(int y, int x) {
    int count = 0;
    count += bombs(y - 1, x);
    count += bombs(y + 1, x);
    count += bombs(y, x - 1);
    count += bombs(y, x + 1);
    count += bombs(y - 1, x - 1);
    count += bombs(y + 1, x + 1);
    count += bombs(y + 1, x - 1);
    count += bombs(y - 1, x + 1);
    return count;
  }

  int bombs(int y, int x) {
    if(_isValidPosition(y, x)){
      if(game.listBombs[y][x]){
        return 1;
      }
    }
    return 0;
  }

  bool _isValidPosition(int posY, int posX) {
    if (posX < 0 || posY < 0) return false;
    if(game.listBombs ==  null) return false;
    if (posY > (game.listBombs.length  - 1)) return false;
    if (posX > (game.listBombs[posY].length  - 1)) return false;
    return true;
  }

  SquareWidget _pickSquareFromList(int posY, int posX) {
    //! If reach to the border, will not found a square.
    if (!_isValidPosition(posY, posX)) return null;
    return listTableRows.value[posY].children[posX] as SquareWidget;
  }

  List<TableRow> _generateTable(GameModel game) {
    return List.generate(
      game.rows,
      (heightRef) => TableRow(
        children: List.generate(
          game.cols,
          (widthRef) => _createSquare(heightRef, widthRef),
        ),
      ),
    );
  }

  Widget _createSquare(int posY, int posX) => SquareWidget(
        colorSwitch: (posX + posY).isOdd,
        posX: posX,
        posY: posY,
        bombProximity: _sideBombs(posY, posX),
        isBomb: game.listBombs[posY][posX],
        initialState: game.listStates[posY][posX],
        onTap: (isBomb, bombs) => this._probePress(posY, posX),
        onLongTap: (isBomb, bombs) => this._flag(posY, posX),
      );

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    listTableRows.close();
  }
}
