import 'package:andersen/core/common/entities/user_entity.dart';
import 'package:andersen/core/common/profile/repository/profile_repository.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.getProfile();
  }
}
