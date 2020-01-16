import 'package:desafio_campo_minado/app/modules/game/widgets/board/board_bloc.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatefulWidget {
  final Function(GameModel newGame) updateDataServer;
  final Stream<GameModel> stream;
  final GameModel Function() getGame;
  final bool Function() isAlive;
  final Function lose;
  final Function win;

  BoardWidget({Key key, this.updateDataServer, this.stream, this.getGame, this.isAlive, this.lose, this.win}) : super(key: key);

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  BoardBloc _bloc;

  @override
  void initState() { 
    _bloc = BoardBloc(widget.updateDataServer, widget.stream, widget.getGame, widget.isAlive, widget.lose, widget.win);
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.listTableRows.stream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Table(
                children: snapshot.data,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
