import 'package:desafio_campo_minado/app/modules/game/game_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class BoardBloc extends Disposable {
  GameModel game;
  var listTableRows = BehaviorSubject<List<TableRow>>();
  GameBloc gameBloc = GameModule.to.get<GameBloc>();
  ScoreBloc scoreBloc = GameModule.to.get<ScoreBloc>();
  StatusGame get statusGame => gameBloc.statusGame.value;
  bool get isAlive => statusGame == StatusGame.running;

  BoardBloc(this.game) {
    listTableRows.sink.add(_generateTable(game));
  }

  void _probePress(int y, int x) {
    if (!isAlive) return;
    SquareWidget square = _pickSquareFromList(y, x);
    if (square.state == SquareState.flag) return;
    if (game.listBombs[y][x]) {
      square.sinkState.add(SquareState.pressed);
      gameBloc.lose();
    } else {
      _pressSquare(y, x);
      scoreBloc.startTimer();
    }
  }

  void _pressSquare(int y, int x) {
    if (!_isValidPosition(y, x)) return;
    SquareWidget square = _pickSquareFromList(y, x);
    if (square.state == SquareState.pressed) return;
    square.sinkState.add(SquareState.pressed);

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
      square.sinkState.add(SquareState.released);
      scoreBloc.addFlag();
    } else {
      square.sinkState.add(SquareState.flag);
      scoreBloc.removeFlag();
    }
    _verifyIfWon();
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
      if(won) gameBloc.win();
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

  int bombs(int y, int x) => _isValidPosition(y, x) && game.listBombs[y][x] ? 1 : 0;
  bool _isValidPosition(int posY, int posX) {
    if (posX < 0 || posY < 0) return false;
    if (posY > (game.listBombs.length - 1)) return false;
    if (posX > (game.listBombs[posY].length - 1)) return false;
    return true;
  }

  SquareWidget _pickSquareFromList(int posY, int posX) {
    //! If reach to the border, will not found a square.
    if (!_isValidPosition(posY, posX)) return null;
    return listTableRows.value[posY].children[posX] as SquareWidget;
  }

  List<TableRow> _generateTable(GameModel game) {
    gameBloc.statusGame.sink.add(StatusGame.running);
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
