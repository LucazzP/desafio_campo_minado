// To parse this JSON data, do
//
//     final gameState = gameStateFromJson(jsonString);

import 'package:desafio_campo_minado/src/modules/game/widgets/board/board_view_model.dart';
import 'package:desafio_campo_minado/src/shared/models/game_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:random_string/random_string.dart';

@immutable
class GameState {
  final int secondsElapsed;
  final GameModel game;
  final StatusGame statusGame;

  GameState({
    @required this.secondsElapsed,
    @required this.game,
    @required this.statusGame,
  });

  GameState copyWith({
    int secondsElapsed,
    GameModel game,
    StatusGame statusGame,
  }) =>
      GameState(
        secondsElapsed: secondsElapsed ?? this.secondsElapsed,
        game: game ?? this.game,
        statusGame: statusGame ?? this.statusGame,
      );

  factory GameState.fromRawJson(String str) =>
      GameState.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        secondsElapsed: json["secondsElapsed"],
        game: GameModel.fromJson(json["game"]),
        statusGame: StatusGame.values[json["statusGame"]],
      );

  factory GameState.initialState() => GameState(
    secondsElapsed: 0,
    game: GameModel(),
    statusGame: StatusGame.running,
  );

  Map<String, dynamic> toJson() => {
        "secondsElapsed": secondsElapsed,
        "game": game.toJson(),
        "statusGame": statusGame.index,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}