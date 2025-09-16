import 'package:andersen/core/error/exceptions.dart';
import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  String get errorMessage => "$statusCode Error: $message";

  @override
  List<Object?> get props => [statusCode, message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ServerException e)
    : this(message: e.message, statusCode: e.statusCode);
}
