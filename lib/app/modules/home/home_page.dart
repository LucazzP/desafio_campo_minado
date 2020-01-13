import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Campo Minado"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController(text: '30');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .5,
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(labelText: 'Numero de bombas:'),
                textAlign: TextAlign.center,
                controller: controller,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(height: 20,),
            RaisedButton(
              onPressed: () => Navigator.of(context).pushNamed('/game', arguments: int.parse(controller.text)),
              child: Text('Ir para o jogo'),
            ),
          ],
        ),
      ),
    );
  }
}
