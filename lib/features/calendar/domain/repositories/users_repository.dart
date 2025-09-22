import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/domain/entities/users_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class UsersRepository {
  Future<Either<Failure, UsersEntity>> getUsers({
    required int limit,
    required int offset,
    String? search,
    String? status,
  });
}
