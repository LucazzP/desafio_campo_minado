import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/board/board_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final GameModel game;

  BoardWidget({Key key, this.game})
      : super(key: key);

  BoardBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BoardBloc(game);
    return StreamBuilder(
      stream: _bloc.listTableRows.stream,
      builder: (context, snapshot) {
        return snapshot.hasData ? Table(
          children: snapshot.data,
        ) : Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
