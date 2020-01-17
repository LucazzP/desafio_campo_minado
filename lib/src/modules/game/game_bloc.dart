import 'dart:async';
import 'dart:math';

import 'package:desafio_campo_minado/src/modules/game/game_module.dart';
import 'package:desafio_campo_minado/src/modules/game/game_repository.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/score/score_bloc.dart';
import 'package:desafio_campo_minado/src/shared/models/game_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:random_string/random_string.dart';
import 'package:rxdart/rxdart.dart';

enum StatusGame { running, won, lose }

class GameBloc extends Disposable {
  BehaviorSubject<StatusGame> statusGame =
      BehaviorSubject<StatusGame>.seeded(StatusGame.running);
  BehaviorSubject<GameModel> _game =
      BehaviorSubject<GameModel>.seeded(GameModel());
  BehaviorSubject<GameModel> _gameServerSide = BehaviorSubject<GameModel>();
  BehaviorSubject<GameModel> newGameObserver = BehaviorSubject<GameModel>();

  var repo = GameModule.to.get<GameRepository>();

  // Game Stream
  set game(GameModel gameModel) {
    if (gameModel != game) {
      _game.sink.add(gameModel);
      if (gameModel.listBombs == null && gameModel.gameCode != null) {
        repo.getGame(gameCode).then((data) {
          if (!_game.isClosed) _game.sink.add(data.mergeWith(gameModel));
          createOrUpdateGameSession(data.mergeWith(gameModel));
        });
      } else {
        createOrUpdateGameSession(gameModel);
      }
    }
  }

  GameModel get game => _game.value;
  Stream<GameModel> get gameOut => _game.stream;

  String get _randomString => randomString(6, from: 65, to: 90);
  String get gameCode {
    String code = _randomString;
    if (game.gameCode == null) {
      game = game.copyWith(gameCode: code);
    }
    return game.gameCode;
  }

  StreamSubscription listener;

  void syncServer() {
    print(gameCode);
    listener = repo.streamGame(gameCode).listen((game) {
      // if (game == GameModel()) resetGame();
      if (gameCode != null && !_gameServerSide.isClosed) {
        if (game.gameCode == _game.value.gameCode) {
          _game.sink.add(game);
        } else
          listener.cancel();
      }
    });
  }

  void win() {
    game = game.copyWith(active: false);
    statusGame.sink.add(StatusGame.won);
  }

  void lose() {
    game = game.copyWith(active: false);
    statusGame.sink.add(StatusGame.lose);
  }

  Future<GameModel> createGame(GameModel gameModel, int rows, int cols,
      [bool reset]) async {
    GameModel _gameModel;
    if (gameModel.gameCode == null || reset) {
      game = game.copyWith(
        listBombs: _createRandomBombList(gameModel.bombs, rows, cols),
        bombs: gameModel.bombs,
        gameCode: gameCode,
      );
      _gameModel = game;
    } else {
      _game.sink.add(game.copyWith(gameCode: gameModel.gameCode));
      _gameModel = await repo.getGame(gameModel.gameCode);
      _game.sink.add(_gameModel);
    }
    syncServer();
    newGameObserver.sink.add(_gameModel);
    return _gameModel;
  }

  Future<void> resetGame(bool newGame) async {
    GameModel lastGame = game;
    repo.deleteGame(lastGame.gameCode);
    if (newGame) {
      game = GameModel(gameCode: _randomString, bombs: lastGame.bombs);
      GameModule.to.get<ScoreBloc>().resetTimer();
      game = await createGame(game, lastGame.rows, lastGame.cols, true);
      statusGame.sink.add(StatusGame.running);
    }
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

  Future createOrUpdateGameSession(GameModel game) async {
    return repo.createOrUpdateGameSession(game);
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    statusGame.close();
    _game.close();
    _gameServerSide.close();
    newGameObserver.close();
  }
}
