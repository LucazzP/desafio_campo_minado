import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_bloc.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:random_string/random_string.dart';
import 'package:rxdart/rxdart.dart';

enum StatusGame { running, won, lose }

class GameBloc extends Disposable {
  BehaviorSubject<StatusGame> statusGame =
      BehaviorSubject<StatusGame>.seeded(StatusGame.running);
  String _gameCode;
  String get _randomString => randomString(6, from: 65, to: 90);
  String get gameCode {
    if (_gameCode == null) {
      _gameCode = _gameCode = _randomString;
    }
    return _gameCode;
  }

  void win() {
    statusGame.sink.add(StatusGame.won);
    GameModule.to.get<ScoreBloc>().stopTimer();
    _gameCode = _randomString;
  }

  void lose() {
    statusGame.sink.add(StatusGame.lose);
    GameModule.to.get<ScoreBloc>().stopTimer();
    _gameCode = _randomString;
  }

  GameModel createGame(int bombs, int rows, int cols) {
    GameModel game = GameModel(listBombs: _createRandomBombList(bombs, rows, cols));
    _createGameSession(game);
    return game;
  }

  List<List<bool>> _createRandomBombList(int bombs, int rows, int cols) {
    var bombList = List<List<bool>>.generate(rows, (row) {
      return List<bool>.filled(cols, false);
    });
    Random _random = Random();
    int remainingMines = bombs;
    while (remainingMines > 0) {
      int row = _random.nextInt(rows);
      int col = _random.nextInt(cols);
      if (!bombList[row][col]) {
        bombList[row][col] = true;
        remainingMines--;
      }
    }
    return bombList;
  }

  void _createGameSession(GameModel game) {
    Firestore.instance.collection("games").document(gameCode).setData(game.toJson());
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    statusGame.close();
  }
}
