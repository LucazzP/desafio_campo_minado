import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/app_module.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/modules/game/redux/game_state.dart';
import 'package:desafio_campo_minado/src/modules/home/redux/home_state.dart';

class States {
  static Store<AppState> get store => AppModule.to.get<Store<AppState>>(); 
  static AppState get appState => store.state;
  static HomeState get homeState => appState.homeState;
  static GameState get gameState => appState.gameState;
}