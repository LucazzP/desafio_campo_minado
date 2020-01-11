import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class BoardBloc extends Disposable {
  List<List<SquareState>> listState;
  final List<List<bool>> listBombs;
  var listRows = BehaviorSubject<List<TableRow>>();

  BoardBloc(int height, int width, this.listBombs) {
    listRows.sink.add(_generateTable(height, width));
  }

  void _refreshSquare(int heightRef, int widthRef) {
    var list = listRows.value;
    list[heightRef].children[widthRef] = _createSquare(heightRef, widthRef, bombs: _verifySquareSidesBombs(heightRef, widthRef));
    listRows.sink.add(list);
  }

  int _verifySquareSidesBombs(int heightRef, int widthRef){
    int bombs = 0;
    var topSquare = _pickSquareFromList(heightRef, widthRef);
    var topLeftSquare = _pickSquareFromList(heightRef, widthRef);
    var topRightSquare = _pickSquareFromList(heightRef, widthRef);
    var rightSquare = _pickSquareFromList(heightRef, widthRef);
    var leftSquare = _pickSquareFromList(heightRef, widthRef);
    var bottomSquare = _pickSquareFromList(heightRef, widthRef);
    var bottomLeftSquare = _pickSquareFromList(heightRef, widthRef);
    var bottomRightSquare = _pickSquareFromList(heightRef, widthRef);
    if(topSquare.isBomb) bombs++;
    if(topLeftSquare.isBomb) bombs++;
    if(topRightSquare.isBomb) bombs++;
    if(rightSquare.isBomb) bombs++;
    if(leftSquare.isBomb) bombs++;
    if(bottomSquare.isBomb) bombs++;
    if(bottomLeftSquare.isBomb) bombs++;
    if(bottomRightSquare.isBomb) bombs++;
    return bombs;
  }

  SquareWidget _pickSquareFromList(int heightRef, int widthRef){
    return listRows.value[heightRef].children[widthRef] as SquareWidget;
  }

  void _changeState(int heightRef, int widthRef, SquareState state) {
    listState[heightRef][widthRef] = state;
    _refreshSquare(heightRef, widthRef);
  }

  List<TableRow> _generateTable(int height, int width) {
    listState = List.generate(height,
        (indexHeight) => List.generate(width, (index) => SquareState.released));
    return List.generate(
      height,
      (heightRef) => TableRow(
        children: List.generate(
          width,
          (widthRef) => _createSquare(heightRef, widthRef),
        ),
      ),
    );
  }

  Widget _createSquare(int heightRef, int widthRef, {int bombs}) => SquareWidget(
        colorSwitch: (widthRef + heightRef).isOdd,
        bombProximity: bombs,
        isBomb: listBombs[heightRef][widthRef],
        state: listState[heightRef][widthRef],
        onTap: () => _changeState(heightRef, widthRef, SquareState.pressed),
        onLongTap: () => _changeState(heightRef, widthRef, SquareState.flag),
      );

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    listRows.close();
  }
}
