import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/data/sources/matters_remote_data_source.dart';
import 'package:andersen/features/tasks/data/sources/task_types_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/entities/matters_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_types_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/task_types_repository.dart';
import 'package:dartz/dartz.dart';

class TaskTypesRepositoryImpl implements TaskTypesRepository {
  final TaskTypesRemoteDataSource remoteDataSource;

  TaskTypesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TaskTypesEntity>> getTypes({
    required int limit,
    required int offset,
    String? search,
  }) async {
    try {
      final result = await remoteDataSource.getTypes(
        offset: offset,
        limit: limit,
        search: search,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
