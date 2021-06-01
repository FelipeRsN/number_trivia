import 'package:trivia_app/core/resource/resource.dart';
import 'package:trivia_app/core/usecases/usecase.dart';
import 'package:trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository!);
  });

  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  final answer =
      Resource<NumberTrivia>(status: Status.success, data: tNumberTrivia);

  test('should get trivia from the repository', () async {
    //arrange
    when(mockNumberTriviaRepository!.getRandomNumberTrivia())
        .thenAnswer((_) async => answer);

    //act
    final result = await usecase!(NoParams());

    //assert
    expect(result, answer);
    verify(mockNumberTriviaRepository!.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
