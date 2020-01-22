import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business/app/app_state.dart';

class ChangeValidCodeAction extends ReduxAction<AppState> {
  final bool valid;

  ChangeValidCodeAction(this.valid);

  @override
  AppState reduce() {
    return state.copyWith(homeState: state.homeState.copyWith(validCode: valid));
  }
}

class LoadingAction extends ReduxAction<AppState> {
  final bool loading;

  LoadingAction(this.loading);

  @override
  AppState reduce() {
    return state.copyWith(homeState: state.homeState.copyWith(loading: loading));
  }
}

class CheckValidCodeAction extends ReduxAction<AppState> {
  final String code;

  CheckValidCodeAction({this.code}) : assert(code != null);

  void before() {
    dispatch(LoadingAction(true));
  }

  void after() {
    dispatch(LoadingAction(false));
  }

  @override
  Future<AppState> reduce() async {
    var snapshot =
        await Firestore.instance.collection('games').document(code).get();
    dispatch(ChangeValidCodeAction(snapshot.exists));
    return null;
  }
}
