import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/create_task_repository.dart';
import 'package:dartz/dartz.dart';

class CreateTaskUsecase {
  final CreateTaskRepository repository;

  CreateTaskUsecase(this.repository);

  Future<Either<Failure, TaskEntity>> call(Map<String, dynamic> body) async {
    return await repository.createTask(body);
  }
}
