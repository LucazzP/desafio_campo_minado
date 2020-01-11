import 'dart:math';

import 'package:flutter_modular/flutter_modular.dart';

class GameBloc extends Disposable {

  List<List<bool>> createGame(int bombs, int height, int width) {
    return _createRandomBombList(bombs, height, width);
  }

  List<List<bool>> _createRandomBombList(int bombs, int height, int width){
    var list = List<List<bool>>.filled(height, List<bool>.filled(width, Random().nextBool()));
    // while (!_verifyList(list, bombs)) {
      // list[2] = List<bool>.filled(width, Random().nextBool());
      print(list);
    // }
    return list;
  }

  bool _verifyList(List<List<bool>> list, int bombs) {
    int bombsOnList = 0;
    list.forEach((l) => bombsOnList += l.where((value) => value).length);
    print(bombsOnList);
    return bombsOnList >= bombs;
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {}
}
