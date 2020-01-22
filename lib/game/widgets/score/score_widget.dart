import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/widgets/score/models/score_view_model.dart';
import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {

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
                StoreConnector<AppState, ScoreViewModel>(
                  model: ScoreViewModel(),
                  builder: (BuildContext context, scoreView){
                    return Text(scoreView.flags.toString());
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
                StoreConnector<AppState, ScoreViewModel>(
                  model: ScoreViewModel(),
                  builder: (BuildContext context, scoreView){
                    return Text(scoreView.secondsElapsed.toString().padLeft(3, '0'));
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
