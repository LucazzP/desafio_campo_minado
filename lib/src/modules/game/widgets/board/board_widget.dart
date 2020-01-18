import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/board/board_view_model.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BoardViewModel>(
      model: BoardViewModel(),
      builder: (context, boardView) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => resultGame(boardView.statusGame, boardView.resetGame, context));
        return boardView.listStates != null
            ? Table(
                children: boardView.generateTable(),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Future<void> resultGame(
      StatusGame status, Function(bool) resetGame, BuildContext context) async {
    if (status != StatusGame.running && status != null) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(status == StatusGame.won ? "Parabéns" : "Puts"),
            content: Text(
              status == StatusGame.won ? "Você ganhou!" : "Você perdeu :(",
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Iniciar novamente"),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ],
          )).then((again) => resetGame(again ?? false));
    }
  }
}
