
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivia_app/core/network/data_connection_checker.dart';
import 'package:trivia_app/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl? networkInfoImpl;
  MockDataConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group("isConnected", () {
    test('should forward the call to DataConnectionChecker.hasConnection', () async {
      //arrange
      final tHasConnectionFuture = Future.value(true);

      when(() => mockDataConnectionChecker!.hasConnection).thenAnswer((_) => tHasConnectionFuture);
    
      //act
      final result = networkInfoImpl!.isConnected;      
    
      //assert
      verify(() => mockDataConnectionChecker!.hasConnection);
      expect(result, tHasConnectionFuture);
      
    });
  });
}
