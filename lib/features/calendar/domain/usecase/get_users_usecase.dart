import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/repositories/users_repository.dart';
import 'package:andersen/features/home/domain/entities/users_entity.dart';
import 'package:dartz/dartz.dart';

class GetUsersUsecase {
  final UsersRepository repository;

  GetUsersUsecase(this.repository);

  Future<Either<Failure, UsersEntity>> call({
    required int limit,
    required int offset,
    String? search,
    String? status,
  }) async {
    return await repository.getUsers(offset: offset, limit: limit, search: search, status: status);
  }
}
