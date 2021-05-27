import '../../../../core/resource/resource.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Resource<NumberTrivia>>? getConcreteNumberTrivia(int number);
  Future<Resource<NumberTrivia>>? getRandomNumberTrivia();
}
