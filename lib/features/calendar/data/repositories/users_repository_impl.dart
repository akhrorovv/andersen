import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/data/sources/users_remote_data_source.dart';
import 'package:andersen/features/calendar/domain/repositories/users_repository.dart';
import 'package:andersen/features/home/domain/entities/users_entity.dart';
import 'package:dartz/dartz.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UsersEntity>> getUsers({
    required int limit,
    required int offset,
    String? search,
    String? status,
  }) async {
    try {
      final result = await remoteDataSource.getUsers(
        offset: offset,
        limit: limit,
        search: search,
        status: status,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
