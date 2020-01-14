import 'package:desafio_campo_minado/app/modules/game/game_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_bloc.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final GameModel game;
  final ScoreBloc bloc = GameModule.to.get<ScoreBloc>();

  ScoreWidget(this.game, {Key key}) : super(key: key){
    bloc.flags.sink.add(game.bombs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Icon(Icons.flag, color: Colors.redAccent,),
                Container(width: 5,),
                StreamBuilder<int>(
                  stream: bloc.flags.stream,
                  initialData: 0,
                  builder: (BuildContext context, snapshot){
                    return Text(snapshot.data.toString());
                  },
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Icon(Icons.timer, color: Colors.yellowAccent,),
                Container(width: 5,),
                StreamBuilder<int>(
                  stream: bloc.secondsElapsed.stream,
                  initialData: 0,
                  builder: (BuildContext context, snapshot){
                    return Text(snapshot.data.toString().padLeft(3, '0'));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
