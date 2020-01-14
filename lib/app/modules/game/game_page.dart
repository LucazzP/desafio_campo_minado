import 'package:desafio_campo_minado/app/modules/game/game_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/board/board_widget.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_widget.dart';
import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
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
  GameBloc bloc = GameModule.to.get<GameBloc>();

  @override
  void initState() {
    bloc.createGame(widget.game, 15, 10, false);
    bloc.statusGame.listen((status) {
      if (status != StatusGame.running) {
        resultGame(status);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: ScoreWidget(),
      ),
      body: StreamBuilder<GameModel>(
        stream: bloc.newGameObserver.stream,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        BoardWidget(
                          stream: bloc.gameOut,
                          getGame: () => bloc.game,
                          isAlive: () =>
                              bloc.statusGame.value == StatusGame.running,
                          updateDataServer: (game) {
                            bloc.game = game;
                          },
                          lose: () => bloc.lose(),
                          win: () => bloc.win(),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .1,
                          child: Center(
                            child: Text(
                              "Código do jogo: ${bloc.gameCode}",
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

  Future<void> resultGame(StatusGame status) async {
    // bloc.game = bloc.game.copyWith(active: false);
    bool again = await showDialog(
        context: context,
        child: AlertDialog(
          title: Text(status == StatusGame.won ? "Parabéns" : "Puts"),
          content: Text(
              status == StatusGame.won ? "Você ganhou!" : "Você perdeu :("),
          actions: <Widget>[
            FlatButton(
              child: Text("Iniciar novamente"),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        ));
    bloc.resetGame(again ?? false);
  }
}
