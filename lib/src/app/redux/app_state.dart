import 'package:desafio_campo_minado/src/modules/game/redux/game_state.dart';
import 'package:desafio_campo_minado/src/modules/home/redux/home_state.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppState {
  final HomeState homeState;
  final GameState gameState;

  AppState({@required this.homeState, @required this.gameState});

  factory AppState.initial() {
    return AppState(
      homeState: HomeState.initialState(),
      gameState: GameState.initialState(),
    );
  }

  AppState copyWith({
    HomeState homeState,
    GameState gameState,
  }) {
    return AppState(
      homeState: homeState ?? this.homeState,
      gameState: gameState ?? this.gameState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          homeState == other.homeState &&
          gameState == other.gameState;

  @override
  int get hashCode => homeState.hashCode ^ gameState.hashCode;
}
