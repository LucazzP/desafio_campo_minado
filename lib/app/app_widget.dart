import 'package:async_redux/async_redux.dart';
import 'package:business/app/app_state.dart';
import 'package:desafio_campo_minado/game/game_page.dart';
import 'package:desafio_campo_minado/home/home_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  final Store<AppState> store;

  const AppWidget({Key key, @required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Campo Minado',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/game': (context) => GamePage(),
        },
      ),
    );
  }
}
