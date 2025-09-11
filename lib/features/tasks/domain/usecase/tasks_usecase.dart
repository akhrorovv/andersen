import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:dartz/dartz.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Future<Either<Failure, TasksEntity>> call() {
    return repository.getTasks();
  }
}
