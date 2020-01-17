import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/modules/home/redux/home_state.dart';

class ChangeValidCodeAction extends ReduxAction<HomeState> {
  final bool valid;

  ChangeValidCodeAction(this.valid) : assert(valid != null);

  @override
  HomeState reduce() {
    return state.copyWith(validCode: valid);
  }
}