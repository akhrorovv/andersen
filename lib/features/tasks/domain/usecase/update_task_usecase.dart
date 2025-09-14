import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/task_detail_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateTaskUsecase {
  final TaskDetailRepository repository;

  UpdateTaskUsecase(this.repository);

  Future<Either<Failure, TaskEntity>> call(
    int taskId,
    Map<String, dynamic> body,
  ) async {
    return await repository.updateTask(taskId, body);
  }
}
