import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/core/error/failures.dart';
import 'package:trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/resource/resource.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

typedef Future<NumberTriviaModel>? _ConcreteOrRandomChoose();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.numberTriviaRemoteDataSource,
    required this.numberTriviaLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Resource<NumberTrivia>>? getConcreteNumberTrivia(int? number) async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Resource<NumberTrivia>>? getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Resource<NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChoose getConcreteOrRandom) async {
    if (await networkInfo.isConnected == true) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        numberTriviaLocalDataSource.cacheNumberTrivia(remoteTrivia);

        return Resource<NumberTrivia>.success(data: remoteTrivia);
      } on ServerException {
        return Resource<NumberTrivia>.error(error: ServerFailure());
      }
    } else {
      try {
        final localTrivia =
            await numberTriviaLocalDataSource.getLastNumberTrivia();

        return Resource<NumberTrivia>.success(data: localTrivia);
      } on CacheException {
        return Resource<NumberTrivia>.error(error: CacheFailure());
      }
    }
  }
}
