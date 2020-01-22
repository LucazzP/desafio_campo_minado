// To parse this JSON data, do
//
//     final homeState = homeStateFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class HomeState {
  final bool validCode;
  final bool loading;

  HomeState({
    @required this.validCode,
    @required this.loading,
  });

  HomeState copyWith({
    bool validCode,
    bool loading,
  }) =>
      HomeState(
        validCode: validCode ?? this.validCode,
        loading: loading ?? this.loading,
      );

  factory HomeState.fromRawJson(String str) =>
      HomeState.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeState.fromJson(Map<String, dynamic> json) => HomeState(
        validCode: json["validCode"],
        loading: json["loading"],
      );

  Map<String, dynamic> toJson() => {
        "validCode": validCode,
        "loading": loading,
      };

  factory HomeState.initialState() => HomeState(
        validCode: null,
        loading: false,
      );

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeState &&
          runtimeType == other.runtimeType &&
          validCode == other.validCode &&
          loading == other.loading;

  @override
  int get hashCode => validCode.hashCode ^ loading.hashCode;
}
