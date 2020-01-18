import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/app/redux/states.dart';
import 'package:desafio_campo_minado/src/modules/game/game_page.dart';
import 'package:desafio_campo_minado/src/modules/game/game_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class GameModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => GameRepository()),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => StoreProvider<AppState>(
            child: GamePage(game: args.data),
            store: States.store,
          ),
        ),
      ];

  static Inject get to => Inject<GameModule>.of();
}
