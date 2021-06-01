import 'package:equatable/equatable.dart';
import 'package:trivia_app/core/usecases/usecase.dart';

import '../../../../core/resource/resource.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Resource<NumberTrivia>?> call(Params params) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  final int number;

  Params({required this.number});

  @override
  List<Object> get props => [number];
}
