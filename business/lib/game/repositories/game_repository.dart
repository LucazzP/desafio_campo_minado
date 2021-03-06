import 'package:business/game/models/game_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameRepository {
  static Stream<GameModel> streamGame(String gameCode) {
    return Firestore.instance
        .collection("games")
        .document(gameCode)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return GameModel();
      return GameModel.fromJson(snapshot.data);
    });
  }

  static Future<GameModel> getGame(String gameCode) async {
    return GameModel.fromJson(
        (await Firestore.instance.collection("games").document(gameCode).get())
            .data);
  }

  static Future<GameModel> createOrUpdateGameSession(GameModel game) async {
    if (game == null) return null;
    DocumentReference ref =
        Firestore.instance.collection("games").document(game.gameCode);
    
    GameModel _game = game;
    // DocumentSnapshot snap = await ref.get();
    // if (snap.exists) {
    //   _game = GameModel.fromJson(snap.data).mergeWith(game);
    // }
    ref.setData(_game.toJson());
    return _game;
  }

  static Future deleteGame(String gameCode) {
    return Firestore.instance.collection('games').document(gameCode).delete();
  }
}
