import 'package:mocktail/mocktail.dart';
import 'package:trivia_app/core/resource/resource.dart';
import 'package:trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository!);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);
  final answer = Resource<NumberTrivia>.success(data: tNumberTrivia);

  test('should get trivia for the number from the repository', () async {
    //arrange
    when(() => mockNumberTriviaRepository!.getConcreteNumberTrivia(number: tNumber))
        .thenAnswer((_) async => answer);

    //act
    final result = await usecase!(Params(number: tNumber));

    //assert
    expect(result, answer);
    verify(() => mockNumberTriviaRepository!.getConcreteNumberTrivia(number: tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
