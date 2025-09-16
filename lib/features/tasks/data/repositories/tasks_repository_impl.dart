import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/data/sources/tasks_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:dartz/dartz.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TasksEntity>> getTasks({
    required int offset,
    required int limit,
    required int assignedStaffId,
    String? status,
    String? search,
  }) async {
    try {
      final result = await remoteDataSource.getTasks(
        offset: offset,
        limit: limit,
        assignedStaffId: assignedStaffId,
        status: status,
        search: search,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
