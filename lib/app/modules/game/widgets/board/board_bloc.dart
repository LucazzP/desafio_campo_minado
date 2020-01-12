import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class BoardBloc extends Disposable {
  List<List<SquareState>> listState;
  final List<List<bool>> listBombs;
  var listRows = BehaviorSubject<List<TableRow>>();

  BoardBloc(int rows, int cols, this.listBombs) {
    listRows.sink.add(_generateTable(rows, cols));
  }

  /// Returns true if the refresh returned one or more bombs
  bool _refreshSquare(int posY, int posX) {
    var list = listRows.value;
    int bombs = _verifySquareSidesBombs(posY, posX);
    list[posY].children[posX] = _createSquare(posY, posX, bombs: bombs);
    listRows.sink.add(list);
    return bombs != null;
  }

  void _refreshSquares(List<Map<String, int>> positions){
    var list = listRows.value;
    positions.forEach((position){
      int x = position['x'];
      int y = position['y'];
      int bombs = _verifySquareSidesBombs(y, x);
      list[y].children[x] = _createSquare(y, x, bombs: bombs);
    });
    listRows.sink.add(list);
  }

  void _refreshSideSquares(int initialY, int initialX) {
    List<Map<String, int>> positionsToRefresh = List<Map<String, int>>();
    _pickAllSideSquares(initialY, initialX).forEach((square) {
      listState[square.posY][square.posX] = SquareState.pressed;
      positionsToRefresh.add({
        'x': square.posX,
        'y': square.posY
      });
      if(!square.isBomb && square.state != SquareState.flag){
        
      }
      // _changeState(square.posY, square.posX, SquareState.pressed);
    });
    _refreshSquares(positionsToRefresh);
  }

  void pressSquare(int posY, posX){
    
  }

  void flagSquare(int posY, posX){

  }

  int _verifySquareSidesBombs(int posY, int posX) {
    int bombs = 0;
    _pickAllSideSquares(posY, posX).forEach((square) {
      if (square?.isBomb ?? false) bombs++;
    });
    if (bombs == 0) bombs = null;
    return bombs;
  }

  List<SquareWidget> _pickAllSideSquares(int posY, int posX) {
    List<SquareWidget> squareList = List<SquareWidget>();
    var topSquare = _pickSquareFromList(posY, posX + 1);
    var topLeftSquare = _pickSquareFromList(posY - 1, posX + 1);
    var topRightSquare = _pickSquareFromList(posY + 1, posX + 1);
    var rightSquare = _pickSquareFromList(posY + 1, posX);
    var leftSquare = _pickSquareFromList(posY - 1, posX);
    var bottomSquare = _pickSquareFromList(posY, posX - 1);
    var bottomLeftSquare = _pickSquareFromList(posY - 1, posX - 1);
    var bottomRightSquare = _pickSquareFromList(posY + 1, posX - 1);
    if (topSquare != null) squareList.add(topSquare);
    if (topLeftSquare != null) squareList.add(topLeftSquare);
    if (topRightSquare != null) squareList.add(topRightSquare);
    if (rightSquare != null) squareList.add(rightSquare);
    if (leftSquare != null) squareList.add(leftSquare);
    if (bottomSquare != null) squareList.add(bottomSquare);
    if (bottomLeftSquare != null) squareList.add(bottomLeftSquare);
    if (bottomRightSquare != null) squareList.add(bottomRightSquare);
    return squareList;
  }

  SquareWidget _pickSquareFromList(int posY, int posX) {
    //! If reach to the border, will not found a square.
    if (posX > (listRows.value.first.children.length - 1) || posX < 0)
      return null;
    if (posY > (listRows.value.length - 1) || posY < 0) return null;
    return listRows.value[posY].children[posX] as SquareWidget;
  }

  void _changeState(int posY, int posX, SquareState state) {
    listState[posY][posX] = state;
    // _refreshSquare(posY, posX);
    if (!_refreshSquare(posY, posX)) _refreshSideSquares(posY, posX);
  }

  List<TableRow> _generateTable(int rows, int cols) {
    listState = List.generate(rows,
        (indexHeight) => List.generate(cols, (index) => SquareState.released));
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

  Widget _createSquare(int posY, int posX, {int bombs}) => SquareWidget(
        colorSwitch: (posX + posY).isOdd,
        posX: posX,
        posY: posY,
        bombProximity: bombs,
        isBomb: listBombs[posY][posX],
        state: listState[posY][posX],
        onTap: () => this.pressSquare(posY, posX),
        onLongTap: () => this.flagSquare(posY, posX),
      );

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    listRows.close();
  }
}
