import 'package:desafio_campo_minado/src/modules/game/game_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

class MockClient extends Mock implements Dio {}

void main() {
  GameRepository repository;
  MockClient client;

  setUp(() {
    repository = GameRepository();
    client = MockClient();
  });

  group('GameRepository Test', () {
    test("First Test", () {
      expect(repository, isInstanceOf<GameRepository>());
    });
  });
}
