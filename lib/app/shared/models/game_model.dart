import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:flutter/foundation.dart';

class GameModel {
  final int rows;
  final int cols;
  final int bombs;
  int flags;
  final DateTime initialTime;
  final String gameCode;
  final List<List<bool>> listBombs;
  List<List<SquareState>> listStates;
  final bool active;

  GameModel(
      {this.gameCode,
      this.active = true,
      this.listBombs,
      this.listStates,
      this.rows = 15,
      this.cols = 10,
      this.bombs,
      this.flags,
      this.initialTime}) {
    this.flags = this.flags ?? bombs;
    if (listStates == null)
      listStates = List.generate(
          rows, (row) => List.generate(cols, (col) => SquareState.released));
  }

  GameModel copyWith(
          {String gameCode,
          int secondsElapsed,
          List<List<bool>> listBombs,
          List<List<SquareState>> listStates,
          int rows,
          int cols,
          int bombs,
          int flags,
          bool active, DateTime initialTime}) =>
      GameModel(
        bombs: bombs ?? this.bombs,
        cols: cols ?? this.cols,
        flags: flags ?? this.flags,
        gameCode: gameCode ?? this.gameCode,
        listBombs: listBombs ?? this.listBombs,
        listStates: listStates ?? this.listStates,
        rows: rows ?? this.rows,
        active: active ?? this.active,
        initialTime: initialTime ?? this.initialTime,
      );

  GameModel mergeWith(GameModel game) => GameModel(
        bombs: game.bombs ?? this.bombs,
        cols: game.cols ?? this.cols,
        flags: game.flags ?? this.flags,
        gameCode: game.gameCode ?? this.gameCode,
        listBombs: game.listBombs ?? this.listBombs,
        listStates: game.listStates ?? this.listStates,
        rows: game.rows ?? this.rows,
        active: game.active ?? this.active,
      );

  factory GameModel.fromJson(Map<String, dynamic> json) => json == null
      ? GameModel()
      : GameModel(
          active: json['active'],
          rows: json['rows'],
          cols: json['cols'],
          bombs: json['bombs'],
          flags: json['flags'],
          gameCode: json['gameCode'],
          initialTime: json['initialTime'] == null ? null : (json['initialTime'] as Timestamp).toDate(),
          listStates: json['listStates'] == null
              ? null
              : json['listStates']
                  .map<List<SquareState>>((list) =>
                      List.castFrom<dynamic, int>(list['list'])
                          .map((state) => SquareState.values[state])
                          .toList())
                  .toList(),
          listBombs: json['listBombs'] == null
              ? null
              : json['listBombs']
                  .map<List<bool>>(
                      (list) => List.castFrom<dynamic, bool>(list['list']))
                  .toList(),
        );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['active'] = active;
    map['rows'] = rows;
    map['cols'] = cols;
    map['bombs'] = bombs;
    map['flags'] = flags;
    map['gameCode'] = gameCode;
    map['initialTime'] = initialTime;
    map['listBombs'] = listBombs == null
        ? null
        : listBombs
            .map<Map<String, List<bool>>>((list) => {"list": list})
            .toList();
    map['listStates'] = listStates == null
        ? null
        : listStates
            .map<Map<String, List<int>>>((list) =>
                {'list': list.map<int>((state) => state.index).toList()})
            .toList();
    return map;
  }

  @override
  int get hashCode =>
      active.hashCode ^
      rows.hashCode ^
      cols.hashCode ^
      bombs.hashCode ^
      flags.hashCode ^
      gameCode.hashCode ^
      initialTime.hashCode ^
      listBombs.hashCode ^
      listStates.hashCode;

  @override
  bool operator ==(other) =>
      this.active == other.active &&
      this.rows == other.rows &&
      this.cols == other.cols &&
      this.bombs == other.bombs &&
      this.flags == other.flags &&
      this.gameCode == other.gameCode &&
      this.initialTime == other.initialTime &&
      this.listBombs == other.listBombs &&
      this.listStates != other.listStates;
}
