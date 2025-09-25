import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/tasks/data/sources/task_detail_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/task_detail_repository.dart';
import 'package:dartz/dartz.dart';

class TaskDetailRepositoryImpl implements TaskDetailRepository {
  final TaskDetailRemoteDataSource remoteDataSource;

  TaskDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TaskEntity>> getTaskDetail({required int taskId}) async {
    try {
      final result = await remoteDataSource.getTaskDetail(taskId: taskId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, ActivitiesEntity>> getTaskActivities({
    required int limit,
    required int offset,
    int? createdById,
    required int taskId,
  }) async {
    try {
      final result = await remoteDataSource.getTaskActivities(
        offset: offset,
        limit: limit,
        createdById: createdById,
        taskId: taskId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(int taskId, Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSource.updateTask(taskId, body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
