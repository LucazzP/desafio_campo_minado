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
        title: ScoreWidget(widget.game),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            BoardWidget(game: bloc.createGame(widget.game.bombs, 15, 10)),
            Expanded(
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
  }

  Future<void> resultGame(StatusGame status) async {
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
    if (again ?? false) {
      setState(() {
        GameModule.to.get<ScoreBloc>().resetTimer();
      });
    }
  }
}
