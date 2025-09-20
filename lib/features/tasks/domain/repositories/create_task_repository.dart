import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class CreateTaskRepository {
  Future<Either<Failure, TaskEntity>> createTask(Map<String, dynamic> body);
}
