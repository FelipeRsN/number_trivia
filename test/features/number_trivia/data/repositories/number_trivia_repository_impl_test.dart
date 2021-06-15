import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/core/error/failures.dart';
import 'package:trivia_app/core/network/network_info.dart';
import 'package:trivia_app/core/resource/resource.dart';
import 'package:trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? numberTriviaRepositoryImpl;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: mockRemoteDataSource!,
      numberTriviaLocalDataSource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);

      //act
      numberTriviaRepositoryImpl!.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result =
            await numberTriviaRepositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        final expectAnswer = Resource<NumberTrivia>.success(data: tNumberTrivia);

        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        expect(result, equals(expectAnswer));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        await numberTriviaRepositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        //act
        final result =
            await numberTriviaRepositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        final expectAnswer = Resource<NumberTrivia>.error(error: ServerFailure());

        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(expectAnswer));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result =
            await numberTriviaRepositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        final expectAnswer = Resource<NumberTrivia>.success(data: tNumberTrivia);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, expectAnswer);
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());

        //act
        final result =
            await numberTriviaRepositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        final expectAnswer = Resource<NumberTrivia>.error(error: CacheFailure());

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, expectAnswer);
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);

      //act
      numberTriviaRepositoryImpl!.getRandomNumberTrivia();

      //assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result =
            await numberTriviaRepositoryImpl!.getRandomNumberTrivia();

        //assert
        final expectAnswer = Resource<NumberTrivia>.success(data: tNumberTrivia);

        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        expect(result, equals(expectAnswer));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        await numberTriviaRepositoryImpl!.getRandomNumberTrivia();

        //assert
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenThrow(ServerException());

        //act
        final result =
            await numberTriviaRepositoryImpl!.getRandomNumberTrivia();

        //assert
        final expectAnswer = Resource<NumberTrivia>.error(error: ServerFailure());

        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(expectAnswer));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result =
            await numberTriviaRepositoryImpl!.getRandomNumberTrivia();

        //assert
        final expectAnswer = Resource<NumberTrivia>.success(data: tNumberTrivia);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, expectAnswer);
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());

        //act
        final result =
            await numberTriviaRepositoryImpl!.getRandomNumberTrivia();

        //assert
        final expectAnswer = Resource<NumberTrivia>.error(error: CacheFailure());

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, expectAnswer);
      });
    });
  });

  
}
