import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:business/app/app_state.dart';

void main() {
  var store = Store<AppState>(
    initialState: AppState.initial(),
  );
  runApp(AppWidget(store: store,));
}