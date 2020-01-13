import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_bloc.dart';
import 'package:flutter/material.dart';

enum SquareState { released, flag, pressed }

class SquareWidget extends StatelessWidget {
  final bool colorSwitch;
  final int posX;
  final int posY;
  /// The returns will update the state of the square, the bool is if a bomb and the int bombProximity
  final Function(bool, int) onTap;
   /// The returns will update the state of the square, the bool is if a bomb and the int bombProximity
  final Function(bool, int) onLongTap;
  final bool isBomb;
  SquareState get state => _bloc.state.value;
  Sink get sinkState => _bloc.state.sink;
  final int bombProximity;

  SquareWidget(
      {Key key,
      this.colorSwitch = true,
      this.onTap,
      this.onLongTap,
      this.bombProximity, this.isBomb, this.posX, this.posY})
      : super(key: key);

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

  final SquareBloc _bloc = SquareBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SquareState>(
      stream: _bloc.state.stream,
      builder: (context, snapshot) {
        return Ink(
          color: snapshot.data != SquareState.pressed
              ? colorSwitch ? Colors.green[400] : Colors.green[600]
              : colorSwitch ? Colors.brown[100] : Colors.brown[200],
          child: InkWell(
            onTap: snapshot.data != SquareState.pressed ? (){
              onTap(isBomb, bombProximity);
            } : null,
            onLongPress: snapshot.data != SquareState.pressed ? (){
              onLongTap(isBomb, bombProximity);
            } : null,
            splashColor: Colors.green[800],
            child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                child: _getIcon()),
          ),
        );
      }
    );
  }

  Widget _getIcon() {
    if(_bloc.state.value == SquareState.flag){
      return Icon(
          Icons.flag,
          color: Colors.red[700],
        );
    } else if(isBomb) {
      return Icon(Icons.ac_unit, color: Colors.red[700],); 
    } else {
      return Text(
          _bloc.state.value == SquareState.pressed
              ? bombProximity != null && bombProximity != 0 ? bombProximity.toString() : ''
              : '',
          style: TextStyle(
              color: colorText[bombProximity],
              fontSize: 20,
              fontWeight: FontWeight.w800),
        );
    }
  }
}
