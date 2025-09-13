import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class TaskDetailRepository {
  Future<Either<Failure, TaskEntity>> getTaskDetail({required int taskId});
}
