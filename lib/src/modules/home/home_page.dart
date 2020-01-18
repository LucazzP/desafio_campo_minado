import 'package:async_redux/async_redux.dart';
import 'package:desafio_campo_minado/src/app/app_module.dart';
import 'package:desafio_campo_minado/src/app/redux/app_state.dart';
import 'package:desafio_campo_minado/src/app/redux/states.dart';
import 'package:desafio_campo_minado/src/modules/game/widgets/square/square_widget.dart';
import 'package:desafio_campo_minado/src/modules/home/redux/home_model.dart';
import 'package:desafio_campo_minado/src/shared/models/game_model.dart';
import 'package:flutter/foundation.dart';
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
  GlobalKey<FormState> formKeyNewGame = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCode = GlobalKey<FormState>();

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
            height: MediaQuery.of(context).size.height * .8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Init new game
                Form(
                  key: formKeyNewGame,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text('Iniciar um novo jogo'),
                          margin: EdgeInsets.all(10),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Numero de bombas:',
                            ),
                            validator: (value) {
                              if (value.isEmpty ||
                                  (int.tryParse(value) ?? 0) <= 0) {
                                return 'A quantidade mínima é 1';
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            controller: controller,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 2,
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (formKeyNewGame.currentState.validate())
                              Navigator.of(context).pushNamed(
                                '/game',
                                arguments: GameModel(
                                  bombs: int.tryParse(controller.text),
                                ),
                              );
                          },
                          child: Text('Ir para o jogo'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                ),

                // With friend
                Form(
                  key: formKeyCode,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text('Juntar-se a um jogo'),
                          margin: EdgeInsets.all(10),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          child: StoreConnector<AppState, HomeModel>(
                            model: HomeModel(),
                            builder: (context, homeModel) {
                              return TextFormField(
                                validator: (value) {
                                  if (value.isEmpty || value.length != 6) {
                                    return 'Código inválido';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Codigo de entrada:',
                                    errorText: (homeModel.valid ?? true)
                                        ? null
                                        : 'Código inválido'),
                                textAlign: TextAlign.center,
                                controller: controllerCode,
                                textCapitalization:
                                    TextCapitalization.characters,
                                maxLength: 6,
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        StoreConnector<AppState, HomeModel>(
                            model: HomeModel(),
                            builder: (context, homeModel) {
                              return RaisedButton(
                                onPressed: !homeModel.loading
                                    ? () async {
                                        String gameCode =
                                            controllerCode.text.toUpperCase();
                                        await homeModel.validateCode(
                                          gameCode,
                                          formKeyCode.currentState,
                                          context,
                                        );
                                        if (States.homeState.validCode) {
                                          Navigator.of(context).pushNamed(
                                            '/game',
                                            arguments: GameModel(
                                              gameCode: gameCode,
                                            ),
                                          );
                                        }
                                      }
                                    : null,
                                child: !homeModel.loading
                                    ? Text('Ir para o jogo')
                                    : SizedBox(
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ),
                                        width: 20,
                                      ),
                              );
                            }),
                      ],
                    ),
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
