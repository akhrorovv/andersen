import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/auth/domain/entities/login_response_entity.dart';
import 'package:andersen/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import 'login_params.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponseEntity>> call(LoginParams params) {
    return repository.login(params);
  }
}
