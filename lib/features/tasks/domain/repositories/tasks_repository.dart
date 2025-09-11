import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class TasksRepository {
  Future<Either<Failure, TasksEntity>> getTasks();
}
