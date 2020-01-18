import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/app/redux/states.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:desafio_campo_minado/src/modules/home/home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
      ];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => StoreProvider<AppState>(
            child: HomePage(),
            store: States.store,
          ),
        ),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
