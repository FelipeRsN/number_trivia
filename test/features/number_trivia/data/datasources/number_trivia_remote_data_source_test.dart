import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements Client {}

class UriFake extends Fake implements Uri {}

void main() {
  NumberTriviaRemoteDataSourceImpl? numberTriviaRemoteDataSourceImpl;
  MockHttpClient? mockHttpClient;

  setUp(() {
    registerFallbackValue(Uri.parse(''));
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient!.get(
          any(),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(() => mockHttpClient!.get(
          any(),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => Response("Something went wrong", 404));
  }

  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();

        //act
        numberTriviaRemoteDataSourceImpl?.getConcreteNumberTrivia(
            number: tNumber);

        //assert
        verify(
          () => mockHttpClient!.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();

        //act
        final result = await numberTriviaRemoteDataSourceImpl
            ?.getConcreteNumberTrivia(number: tNumber);

        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is different of 200',
      () async {
        //arrange
        setUpMockHttpClientFailure();

        //act
        final call = numberTriviaRemoteDataSourceImpl!.getConcreteNumberTrivia;

        //assert
        expect(() => call(number: tNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group("getRandomNumberTrivia", () {
    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();

        //act
        numberTriviaRemoteDataSourceImpl?.getRandomNumberTrivia();

        //assert
        verify(
          () => mockHttpClient!.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();

        //act
        final result =
            await numberTriviaRemoteDataSourceImpl?.getRandomNumberTrivia();

        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is different of 200',
      () async {
        //arrange
        setUpMockHttpClientFailure();

        //act
        final call = numberTriviaRemoteDataSourceImpl!.getRandomNumberTrivia;

        //assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
