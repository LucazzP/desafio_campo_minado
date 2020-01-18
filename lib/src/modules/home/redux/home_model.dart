import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/modules/home/redux/home_actions.dart';
import 'package:flutter/widgets.dart';

class HomeModel extends BaseModel<AppState> {
  final bool valid;
  final bool loading;
  final Store<AppState> store;

  HomeModel({this.valid, this.loading, this.store}) : super(equals: [valid, loading]);

  Future<void> validateCode(
      String code, FormState formState, BuildContext context) {
    if (!formState.validate()) {
      store.dispatch(ChangeValidCodeAction(false));
      return null;
    }
    return store.dispatchFuture(CheckValidCodeAction(code: code));
  }

  @override
  BaseModel fromStore() => HomeModel(
        valid: state.homeState.validCode,
        loading: state.homeState.loading,
        store: super.store,
      );
}
