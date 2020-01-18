import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/modules/game/game_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:desafio_campo_minado/src/app/app_widget.dart';
import 'package:desafio_campo_minado/src/modules/home/home_module.dart';

class AppModule extends MainModule {
  final Store<AppState> store;

  AppModule(this.store);

  @override
  List<Bind> get binds => [
        Bind((i) => store),
      ];

  @override
  List<Router> get routers => [
        Router('/', module: HomeModule()),
        Router('/game', module: GameModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
