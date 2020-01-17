import 'package:desafio_campo_minado/src/modules/game/widgets/square/square_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class SquareBloc extends Disposable {
  BehaviorSubject<SquareState> state = BehaviorSubject<SquareState>.seeded(SquareState.released);
  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    state.close();
  }
}
