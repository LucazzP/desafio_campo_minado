import 'package:desafio_campo_minado/app/shared/models/game_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Campo Minado"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController(text: '30');
  final TextEditingController controllerCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .55,
            height: MediaQuery.of(context).size.height *.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                // Init new game
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(child: Text('Iniciar um novo jogo'), margin: EdgeInsets.all(10),),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Numero de bombas:'),
                          textAlign: TextAlign.center,
                          controller: controller,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                        ),
                      ),
                      Container(height: 20,),
                      RaisedButton(
                        onPressed: () => Navigator.of(context).pushNamed('/game', arguments: GameModel(bombs: int.parse(controller.text))),
                        child: Text('Ir para o jogo'),
                      ),
                    ],
                  ),
                ),
                Container(height: 50,),

                // With friend
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(child: Text('Juntar-se a um jogo'), margin: EdgeInsets.all(10),),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Codigo de entrada:'),
                          textAlign: TextAlign.center,
                          controller: controllerCode,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 6,
                        ),
                      ),
                      Container(height: 20,),
                      RaisedButton(
                        onPressed: () => Navigator.of(context).pushNamed('/game', arguments: 10),
                        child: Text('Ir para o jogo'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
