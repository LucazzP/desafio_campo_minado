import 'package:flutter/material.dart';
import 'package:business/business.dart';

class SquareWidget extends StatelessWidget {
  final bool colorSwitch;
  final int posX;
  final int posY;
  final Function(bool, int) onTap;
  final Function(bool, int) onLongTap;
  final bool isBomb;
  final int bombProximity;
  final SquareState state;

  SquareWidget({
    Key key,
    this.colorSwitch = true,
    this.onTap,
    this.onLongTap,
    this.bombProximity,
    this.isBomb,
    this.posX,
    this.posY,
    this.state,
  }) : super(key: key);

  final Map<int, Color> colorText = <int, Color>{
    1: Colors.blue[800],
    2: Colors.green[800],
    3: Colors.red[700],
    4: Colors.purple[800],
    5: Colors.black,
    6: Colors.amber,
    7: Colors.orange,
    8: Colors.deepOrange,
    9: Colors.blueGrey,
  };

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: state != SquareState.pressed
          ? colorSwitch ? Colors.green[400] : Colors.green[600]
          : colorSwitch ? Colors.brown[100] : Colors.brown[200],
      child: InkWell(
        onTap: state != SquareState.pressed
            ? () {
                onTap(isBomb, bombProximity);
              }
            : null,
        onLongPress: state != SquareState.pressed
            ? () {
                onLongTap(isBomb, bombProximity);
              }
            : null,
        splashColor: Colors.green[800],
        child: Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            child: _getIcon()),
      ),
    );
  }

  Widget _getIcon() {
    if (state == SquareState.flag) {
      return Icon(
        Icons.flag,
        color: Colors.red[700],
      );
    } else if (isBomb && state == SquareState.pressed) {
      return Text("💣");
    } else {
      return Text(
        state == SquareState.pressed
            ? bombProximity != null && bombProximity != 0
                ? bombProximity.toString()
                : ''
            : '',
        style: TextStyle(
            color: colorText[bombProximity],
            fontSize: 20,
            fontWeight: FontWeight.w800),
      );
    }
  }
}
