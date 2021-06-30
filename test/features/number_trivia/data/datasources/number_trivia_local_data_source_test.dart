import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl? numberTriviaLocalDataSourceImpl;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group("getLastNumberTrivia", () {
    final fixtureName = "trivia_cached.json";
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture(fixtureName)));

    test(
        'should return NumberTriviaModel from sharedPreferences when there is one in the cache',
        () async {
      //arrange
      when(() => mockSharedPreferences?.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(fixture(fixtureName));

      //act
      final result =
          await numberTriviaLocalDataSourceImpl!.getLastNumberTrivia();

      //assert
      verify(() => mockSharedPreferences!.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });

    test('should throw a CacheException when theres is not a cached value',
        () async {
      //arrange
      when(() => mockSharedPreferences?.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(null);

      //act
      final call = numberTriviaLocalDataSourceImpl!.getLastNumberTrivia;

      //assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group("cacheNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: "Test Trivia", number: 1);

    test('should call sharedPreferences to cache the data', () async {
      //arrange
      when(() => mockSharedPreferences?.setString(any(), any())).thenAnswer((_) async => true);

      //act
      numberTriviaLocalDataSourceImpl!.cacheNumberTrivia(tNumberTriviaModel);
      
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences?.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
