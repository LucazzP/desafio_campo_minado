import 'dart:convert';

import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:flutter/foundation.dart';

class GameModel {
  final int rows;
  final int cols;
  final int bombs;
  int flags;
  final String gameCode;
  final int secondsElapsed;
  final List<List<bool>> listBombs;
  List<List<SquareState>> listStates;

  GameModel({this.gameCode, this.secondsElapsed, this.listBombs, this.listStates, this.rows = 15, this.cols = 10, this.bombs, this.flags}){
    this.flags = bombs;
    if(listStates == null) listStates = List.generate(rows, (row) => List.generate(cols, (col) => SquareState.released));
  }

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
    rows: json['rows'],
    cols: json['cols'],
    bombs: json['bombs'],
    flags: json['flags'],
    gameCode: json['gameCode'],
    secondsElapsed: json['secondsElapsed'],
    listBombs: json['listBombs'],
    listStates: List.from((json['listStates'] as List<String>).map<List<SquareState>>((list) => (List.from(jsonDecode(list))).map<SquareState>((state) => SquareState.values[state])))
  );

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = Map<String, dynamic>();
    List<Map<String, List>> list = listStates.map<Map<String, List<int>>>((list) => {'list': list.map<int>((state) => state.index).toList()}).toList();
    map['rows'] = rows;
    map['cols'] = cols;
    map['bombs'] = bombs;
    map['flags'] = flags;
    map['gameCode'] = gameCode;
    map['secondsElapsed'] = secondsElapsed;
    map['listBombs'] = listBombs;
    map['listStates'] = list.toString();
    return map;
  }
}