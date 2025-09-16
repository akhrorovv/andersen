import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class TaskDetailRepository {
  Future<Either<Failure, TaskEntity>> getTaskDetail({required int taskId});

  Future<Either<Failure, ActivitiesEntity>> getTaskActivities({
    required int limit,
    required int offset,
    int? createdById,
    required int taskId,
  });

  Future<Either<Failure, TaskEntity>> updateTask(
    int taskId,
    Map<String, dynamic> body,
  );
}
