import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/auth/domain/entities/login_response_entity.dart';
import 'package:andersen/features/auth/domain/usecases/login_params.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> login(LoginParams params);
}
