import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:desafio_campo_minado/src/app/app_module.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/board/board_bloc.dart';
import 'package:desafio_campo_minado/src/modules/game/game_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(GameModule());
  BoardBloc bloc;

  setUp(() {
    bloc = GameModule.to.get<BoardBloc>();
  });

  group('BoardBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<BoardBloc>());
    });
  });
}
