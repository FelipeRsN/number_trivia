import '../../../../core/resource/resource.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia(this.numberTriviaRepository);

  Future<Resource<NumberTrivia>?> execute({required int number}) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(number);
  }
}
