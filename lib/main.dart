import 'package:desafio_campo_minado/src/app/redux/app_store.dart';
import 'package:flutter/material.dart';
import 'package:desafio_campo_minado/src/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  var store = createStore();
  runApp(ModularApp(module: AppModule(store)));
}