import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';

class GameRepository extends Disposable {
  Stream<GameModel> streamGame(String gameCode) {
    return Firestore.instance
        .collection("games")
        .document(gameCode)
        .snapshots()
        .map((snapshot) {
          if(!snapshot.exists) return GameModel();
          return GameModel.fromJson(snapshot.data);
        });
  }
  Future<GameModel> getGame(String gameCode) async {
    return GameModel.fromJson((await Firestore.instance
        .collection("games")
        .document(gameCode)
        .get()).data);
  }

  Future createOrUpdateGameSession(GameModel game) {
    return Firestore.instance
        .collection("games")
        .document(game.gameCode)
        .setData(game.toJson());
  }

  Future deleteGame(String gameCode) {
    return Firestore.instance.collection('games').document(gameCode).delete();
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
