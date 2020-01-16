import 'package:desafio_campo_minado/app/modules/game/game_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/game_page.dart';
import 'package:desafio_campo_minado/app/modules/game/game_repository.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class GameModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => GameRepository()),
        Bind((i) => ScoreBloc()),
        Bind((i) => GameBloc()),
      ];

  @override
  List<Router> get routers => [
        Router('/', child: (_, args) => GamePage(game: args.data)),
      ];

  static Inject get to => Inject<GameModule>.of();
}
