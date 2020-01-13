import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class BoardBloc extends Disposable {
  final List<List<bool>> listBombs;
  bool alive = false;
  var listRows = BehaviorSubject<List<TableRow>>();

  BoardBloc(int rows, int cols, this.listBombs) {
    listRows.sink.add(_generateTable(rows, cols));
  }

  void _probePress(int y, int x) {
    if (!alive) return;
    SquareWidget square = _pickSquareFromList(y, x);
    if (square.state == SquareState.flag) return;
    if (listBombs[y][x]) {
      square.sinkState.add(SquareState.pressed);
      alive = false;
      // timer.cancel();
      // stopwatch.stop(); // force the stopwatch to stop.
    } else {
      _pressSquare(y, x);
      // if (!stopwatch.isRunning) stopwatch.start();
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
    if (!alive) return;
    SquareWidget square = _pickSquareFromList(y, x);
    if (square.state == SquareState.flag) {
      square.sinkState.add(SquareState.released);
      // --minesFound;
    } else {
      square.sinkState.add(SquareState.flag);
      // ++minesFound;
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

  int bombs(int y, int x) => _isValidPosition(y, x) && listBombs[y][x] ? 1 : 0;
  bool _isValidPosition(int posY, int posX) {
    if (posX < 0 || posY < 0) return false;
    if (posY > (listBombs.length - 1)) return false;
    if (posX > (listBombs[posY].length - 1)) return false;
    return true;
  }

  SquareWidget _pickSquareFromList(int posY, int posX) {
    //! If reach to the border, will not found a square.
    if (!_isValidPosition(posY, posX)) return null;
    return listRows.value[posY].children[posX] as SquareWidget;
  }

  List<TableRow> _generateTable(int rows, int cols) {
    alive = true;
    return List.generate(
      rows,
      (heightRef) => TableRow(
        children: List.generate(
          cols,
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
        isBomb: listBombs[posY][posX],
        onTap: (isBomb, bombs) => this._probePress(posY, posX),
        onLongTap: (isBomb, bombs) => this._flag(posY, posX),
      );

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    listRows.close();
  }
}
