import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/data/sources/task_detail_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/task_detail_repository.dart';
import 'package:dartz/dartz.dart';

class TaskDetailRepositoryImpl implements TaskDetailRepository {
  final TaskDetailRemoteDataSource remoteDataSource;

  TaskDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TaskEntity>> getTaskDetail({
    required int taskId,
  }) async {
    try {
      final result = await remoteDataSource.getTaskDetail(taskId: taskId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
