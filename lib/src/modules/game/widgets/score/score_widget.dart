import 'package:desafio_campo_minado/src/modules/game/game_bloc.dart';
import 'package:desafio_campo_minado/src/modules/game/game_module.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/score/score_bloc.dart';
import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final ScoreBloc bloc = GameModule.to.get<ScoreBloc>();
  final GameBloc gameBloc = GameModule.to.get<GameBloc>();

  ScoreWidget({Key key}) : super(key: key){
    if(gameBloc.game.bombs != null) bloc.flags.sink.add(gameBloc.game.bombs);
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
