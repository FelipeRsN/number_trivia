import '../../../../core/platform/network_info.dart';
import '../../../../core/resource/resource.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

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
  Future<Resource<NumberTrivia>>? getConcreteNumberTrivia(int? number) {
    throw UnimplementedError();
  }

  @override
  Future<Resource<NumberTrivia>>? getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
