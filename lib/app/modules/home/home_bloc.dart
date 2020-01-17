import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Disposable {

  BehaviorSubject<bool> validCode = BehaviorSubject<bool>.seeded(true);

  Future<bool> verifyCode(String code) async {
    var snapshot = await Firestore.instance.collection('games').document(code).get();
    return snapshot.exists;
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    validCode.close();
  }
}
