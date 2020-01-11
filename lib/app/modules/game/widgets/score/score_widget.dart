import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text("Cliques: "),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text("Bombas: "),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text("Tempo: "),
            ),
          )
        ],
      ),
    );
  }
}
