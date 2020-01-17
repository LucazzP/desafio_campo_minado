import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';

Store<AppState> createStore() {
  return Store<AppState>(
    initialState: AppState.initial(),
  );
}