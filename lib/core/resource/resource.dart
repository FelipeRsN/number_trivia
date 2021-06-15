import 'package:equatable/equatable.dart';
import 'package:trivia_app/core/error/failures.dart';

// ignore: must_be_immutable
class Resource<T> extends Equatable {
  Status status;
  T? data;
  Failure? errorMessage;

  Resource._({required this.status, this.data, this.errorMessage});

  factory Resource.success({T? data}) {
    return Resource._(status: Status.success, data: data);
  }

  factory Resource.loading() {
    return Resource._(status: Status.loading);
  }

  factory Resource.error({Failure? error}) {
    return Resource._(status: Status.error, errorMessage: error);
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}

enum Status {
  success,
  loading,
  error,
}
