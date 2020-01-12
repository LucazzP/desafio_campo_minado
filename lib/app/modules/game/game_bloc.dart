import 'dart:math';
import 'package:flutter_modular/flutter_modular.dart';

class GameBloc extends Disposable {

  List<List<bool>> createGame(int bombs, int rows, int cols) {
    return _createRandomBombList(bombs, rows, cols);
  }

  List<List<bool>> _createRandomBombList(int bombs, int rows, int cols){
    var bombList = List<List<bool>>.generate(rows, (row){
      return List<bool>.filled(cols, false);
    });
    Random _random = Random();
    int remainingMines = bombs;
    while (remainingMines > 0) {
      int row = _random.nextInt(rows);
      int col = _random.nextInt(cols);
      if(!bombList[row][col]){
        bombList[row][col] = true;
        remainingMines--;
      }
    }
    return bombList;
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {}
}
