import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/widgets/board/models/board_view_model.dart';
import 'package:desafio_campo_minado/game/widgets/square/square_widget.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BoardViewModel>(
      model: BoardViewModel(),
      onWillChange: (boardView) => WidgetsBinding.instance.addPostFrameCallback(
            (_) => resultGame(boardView.victory, boardView.resetGame, context)),
      builder: (context, boardView) {
        return boardView.listStates != null
            ? Table(
                children: generateTable(boardView),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  List<TableRow> generateTable(BoardViewModel boardView) {
    return List.generate(
      boardView.rows,
      (heightRef) => TableRow(
        children: List.generate(
          boardView.cols,
          (widthRef) =>
              _createSquare(heightRef, widthRef, boardView),
        ),
      ),
    );
  }

  Widget _createSquare(int posY, int posX, BoardViewModel boardView) =>
      SquareWidget(
        colorSwitch: (posX + posY).isOdd,
        posX: posX,
        posY: posY,
        bombProximity: boardView.sideBombs(posY, posX),
        isBomb: boardView.listBombs[posY][posX],
        state: boardView.listStates[posY][posX],
        onTap: (isBomb, bombs) => boardView.probePress(posY, posX),
        onLongTap: (isBomb, bombs) => boardView.flag(posY, posX),
      );

  Future<void> resultGame(bool victory, Function(bool) resetGame, BuildContext context) async {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(victory ? "Parabéns" : "Puts"),
            content: Text(
              victory ? "Você ganhou!" : "Você perdeu :(",
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
