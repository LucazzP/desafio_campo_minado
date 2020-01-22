import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:business/game/actions/game_actions.dart';
import 'package:business/game/models/game_model.dart';
import 'package:business/game/models/game_view_model.dart';
import 'package:desafio_campo_minado/game/widgets/board/board_widget.dart';
import 'package:desafio_campo_minado/game/widgets/score/score_widget.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameModel game = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: ScoreWidget(),
      ),
      body: StoreConnector<AppState, GameViewModel>(
        model: GameViewModel(),
        onInit: (store) => store.dispatch(
          CreateGameAction(
            bombs: game.bombs,
            cols: 10,
            rows: 15,
            gameCode: game.gameCode,
          ),
        ),
        builder: (context, gameView) {
          print(gameView.gameCode);
          return !gameView.ready
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                 )
              : Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        BoardWidget(),
                        Container(
                          height: MediaQuery.of(context).size.height * .1,
                          child: Center(
                            child: Text(
                              "Código do jogo: ${gameView.gameCode}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
