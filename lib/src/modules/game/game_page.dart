import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/modules/game/redux/game_actions.dart';
import 'package:desafio_campo_minado/src/modules/game/redux/game_view_model.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/board/board_widget.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/score/score_widget.dart';
import 'package:desafio_campo_minado/src/shared/models/game_model.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String title;
  final GameModel game;

  const GamePage({Key key, this.title = "Jogo", @required this.game})
      : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: ScoreWidget(),
      ),
      body: StoreConnector<AppState, GameViewModel>(
        model: GameViewModel(),
        onInit: (store) => store.dispatch(CreateGameAction(
            bombs: widget.game.bombs,
            cols: 10,
            rows: 15,
            gameCode: widget.game.gameCode)),
        builder: (context, gameView) {
          print(gameView.gameCode);
          return !gameView.ready
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ))
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
