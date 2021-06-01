
import '../../../../core/resource/resource.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';



class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Resource<NumberTrivia>?> call(NoParams params) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}
