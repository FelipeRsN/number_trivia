import '../../../../core/resource/resource.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Resource<NumberTrivia>>? getConcreteNumberTrivia({required int number});
  Future<Resource<NumberTrivia>>? getRandomNumberTrivia();
}
