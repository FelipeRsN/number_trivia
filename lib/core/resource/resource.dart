import 'package:equatable/equatable.dart';
import 'package:trivia_app/core/error/failures.dart';

class Resource<T> extends Equatable {
  final Status status;
  final T? data;
  final Failure? errorMessage;

  Resource({required this.status, this.data, this.errorMessage});

  Resource success({T? data}) {
    return Resource(status: Status.success, data: data);
  }

  Resource loading() {
    return Resource(status: Status.loading);
  }

  Resource error({Failure? error}) {
    return Resource(status: Status.error, errorMessage: error);
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}

enum Status {
  success,
  loading,
  error,
}
