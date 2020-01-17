// To parse this JSON data, do
//
//     final homeState = homeStateFromJson(jsonString);

import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class HomeState extends BaseModel<AppState> {
  final bool validCode;

  HomeState({
    @required this.validCode,
  });

  HomeState copyWith({
    bool validCode,
  }) =>
      HomeState(
        validCode: validCode ?? this.validCode,
      );

  factory HomeState.fromRawJson(String str) =>
      HomeState.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeState.fromJson(Map<String, dynamic> json) => HomeState(
        validCode: json["validCode"],
      );

  Map<String, dynamic> toJson() => {
        "validCode": validCode,
      };

  factory HomeState.initialState() => HomeState(
        validCode: true,
      );

  @override
  BaseModel fromStore() => HomeState();
}
