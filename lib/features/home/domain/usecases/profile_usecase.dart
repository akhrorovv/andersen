import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/domain/entities/user_entity.dart';
import 'package:andersen/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetProfileUseCase {
  final HomeRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.getProfile();
  }
}
