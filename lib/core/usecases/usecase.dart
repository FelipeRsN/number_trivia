import 'package:equatable/equatable.dart';
import 'package:trivia_app/core/resource/resource.dart';

abstract class UseCase<T, Params> {
  Future<Resource<T>?> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
