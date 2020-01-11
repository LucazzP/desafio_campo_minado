import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/board/board_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/square/square_widget.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final int height;
  final int width;
  final List<List<bool>> listBombs;

  BoardWidget({Key key, this.height = 15, this.width = 10, @required this.listBombs})
      : super(key: key);

  BoardBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BoardBloc(height, width, listBombs);
    return StreamBuilder(
      stream: _bloc.listRows.stream,
      builder: (context, snapshot) {
        return snapshot.hasData ? Table(
          children: snapshot.data,
        ) : Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
