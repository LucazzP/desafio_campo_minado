import 'package:desafio_campo_minado/app/modules/game/game_bloc.dart';
import 'package:desafio_campo_minado/app/modules/game/game_module.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/board/board_widget.dart';
import 'package:desafio_campo_minado/app/modules/game/widgets/score/score_widget.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String title;
  final int bombs;

  const GamePage({Key key, this.title = "Jogo", this.bombs = 15}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    // print(GameModule.to.get<GameBloc>().createGame(widget.bombs, 15, 10));
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: ScoreWidget(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: BoardWidget(listBombs: GameModule.to.get<GameBloc>().createGame(widget.bombs, 15, 10),)
      ),
    );
  }
}
